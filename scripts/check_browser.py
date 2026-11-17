"""Bounded Chrome widget checks; isolates the Flutter Windows URL-path workaround."""

import hashlib
import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
from urllib.parse import urljoin

from claude_pilot import LOGS, ROOT, run_process


def main():
    flutter = shutil.which("flutter")
    if not flutter:
        raise RuntimeError("Flutter is not on PATH")
    sdk = Path(flutter).resolve().parent.parent
    source = sdk / "packages/flutter_tools"
    handler = Path("lib/src/test/flutter_web_platform.dart")
    original = (source / handler).read_bytes()
    text = original.decode("utf-8").replace("\r\n", "\n")
    needle = ("shelf.Response _localCanvasKitHandler(shelf.Request request) {\n"
              "    final String fullPath = _fileSystem.path.fromUri(request.url);")
    workaround = os.name == "nt" and text.count(needle) == 1
    if shutil.disk_usage(ROOT).free < 2_000_000_000:
        raise RuntimeError("Browser checks require a 2 GB free-space reserve")
    (ROOT / ".dart_tool").mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="browser_tools_", dir=ROOT / ".dart_tool") as directory:
        env = os.environ.copy()
        env["FLUTTER_ROOT"] = str(sdk)
        env["CI"] = "true"
        command = [flutter]
        if workaround:
            # Only a disposable copy is changed. URL classification must not use
            # Windows filesystem separators. See flutter/flutter#192069.
            copy = Path(directory)
            for name in ("bin", "lib"):
                shutil.copytree(source / name, copy / name)
            shutil.copyfile(source / "pubspec.yaml", copy / "pubspec.yaml")
            shutil.copyfile(sdk / "LICENSE", copy / "LICENSE")
            config_source = source / ".dart_tool/package_config.json"
            config = json.loads(config_source.read_text(encoding="utf-8"))
            for package in config["packages"]:
                package["rootUri"] = (copy.as_uri() + "/") if package["name"] == "flutter_tools" else urljoin(config_source.as_uri(), package["rootUri"])
            (copy / ".dart_tool").mkdir()
            config_path = copy / ".dart_tool/package_config.json"
            config_path.write_text(json.dumps(config), encoding="utf-8")
            (copy / handler).write_text(text.replace(needle, needle.replace(
                "_fileSystem.path.fromUri(request.url)", "request.url.path")), encoding="utf-8")
            command = [str(sdk / "bin/cache/dart-sdk/bin/dart.exe"),
                       "--packages=" + str(config_path), str(copy / "bin/flutter_tools.dart")]
        command += ["test", "--no-pub", "--platform", "chrome", "test/widget_test.dart"]
        result = run_process(command, ROOT, 180, env=env, min_free_bytes=2_000_000_000)
        result["windows_path_workaround"] = workaround
        result["installed_handler_sha256"] = hashlib.sha256(original).hexdigest()
        result["installed_handler_unchanged"] = (source / handler).read_bytes() == original
        LOGS.mkdir(parents=True, exist_ok=True)
        (LOGS / "browser-check.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
        print(result["stdout"], end="")
        print(result["stderr"], end="", file=sys.stderr)
        print("Windows URL-path workaround:", workaround)
        if result["timed_out"] or result["resource_limited"] or not result["installed_handler_unchanged"]:
            return 1
        return result["exit_code"]


if __name__ == "__main__":
    sys.exit(main())
