"""Local controller checks; never invokes Claude or a network provider."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

from claude_pilot import ResourceLimitReached, load_task, redact, run_process, validate_proposal, validate_response


class PilotTests(unittest.TestCase):
    def test_success(self):
        result = run_process([sys.executable, "-c", "print('ok')"], Path.cwd(), 5)
        self.assertEqual(result["exit_code"], 0)
        self.assertFalse(result["timed_out"])
        self.assertEqual(result["stdout"].strip(), "ok")

    def test_failed_command(self):
        result = run_process([sys.executable, "-c", "raise SystemExit(7)"], Path.cwd(), 5)
        self.assertEqual(result["exit_code"], 7)

    def test_disk_guard_prevents_launch(self):
        with patch('claude_pilot.shutil.disk_usage', return_value=SimpleNamespace(free=0)), patch('claude_pilot.subprocess.Popen') as launch:
            with self.assertRaises(ResourceLimitReached):
                run_process([sys.executable, '-c', 'pass'], Path.cwd(), 5, min_free_bytes=100)
            launch.assert_not_called()

    def test_disk_guard_terminates_running_worker(self):
        with patch('claude_pilot.shutil.disk_usage', side_effect=[SimpleNamespace(free=1000), SimpleNamespace(free=0)]):
            result = run_process([sys.executable, '-c', 'import time; time.sleep(30)'], Path.cwd(), 5, min_free_bytes=100)
        self.assertTrue(result['resource_limited'])
        self.assertFalse(result['timed_out'])
        self.assertNotEqual(result['exit_code'], 0)

    def test_timeout_kills_spawned_child(self):
        with tempfile.TemporaryDirectory() as directory:
            marker = Path(directory) / "child-survived.txt"
            child = f"import time; from pathlib import Path; time.sleep(2); Path({str(marker)!r}).touch()"
            parent = f"import subprocess,sys,time; subprocess.Popen([sys.executable,'-c',{child!r}]); time.sleep(30)"
            result = run_process([sys.executable, "-c", parent], directory, 0.5)
            self.assertTrue(result["timed_out"])
            # A separate process gives a surviving child enough time to write its marker.
            subprocess.run([sys.executable, "-c", "import time; time.sleep(2.5)"], check=True)
            self.assertFalse(marker.exists(), "Timed-out worker's child survived")

    def test_response_fails_closed(self):
        result = {"timed_out": False, "exit_code": 0, "stdout": "not json"}
        self.assertFalse(validate_response(result))
        for response in (
            {"type": "result", "subtype": "error_max_turns", "is_error": True},
            {"type": "result", "subtype": "success", "is_error": False,
             "result": "GYM_PILOT_OK", "permission_denials": [{"tool": "Write"}]},
        ):
            result["stdout"] = json.dumps(response)
            self.assertFalse(validate_response(result))
        result["stdout"] = json.dumps({"type": "result", "subtype": "success",
                                      "is_error": False, "result": "GYM_PILOT_OK"})
        self.assertTrue(validate_response(result))

    def test_known_credentials_are_redacted(self):
        self.assertEqual(redact("token=example-secret", ["example-secret"]), "token=[REDACTED]")

    def test_proposal_rejects_unapproved_paths(self):
        result = {"timed_out": False, "exit_code": 0, "stdout": json.dumps({
            "subtype": "success", "is_error": False,
            "result": json.dumps({"files": {"../outside.dart": "content"}}),
        })}
        with self.assertRaises(ValueError):
            validate_proposal(result)

    def test_proposal_accepts_only_explicit_provider_wrapper(self):
        proposal = {"files": {name: "content" for name in (
            "lib/main.dart", "lib/app/app.dart", "docs/ARCHITECTURE.md")}}
        for payload in (json.dumps(proposal),
                        "<thinking>provider prefix</thinking>\n" + json.dumps(proposal),
                        "```json\n" + json.dumps(proposal) + "\n```",
                        "Reading task.\n```json\n" + json.dumps(proposal) + "\n```\nDone.",
                        "<thinking>provider prefix</thinking>\n```json\n" + json.dumps(proposal) + "\n```"):
            result = {"timed_out": False, "exit_code": 0, "stdout": json.dumps({
                "subtype": "success", "is_error": False, "result": payload})}
            self.assertEqual(validate_proposal(result), proposal)
            with self.assertRaises(ValueError):
                validate_proposal(result, [])
        result["stdout"] = json.dumps({"subtype": "success", "is_error": False,
                                       "result": "arbitrary prose " + json.dumps(proposal)})
        with self.assertRaises(ValueError):
            validate_proposal(result)
        result["stdout"] = json.dumps({"subtype": "success", "is_error": False,
                                       "result": "```json\n" + json.dumps(proposal) + "\n```\n```json\n{}\n```"})
        with self.assertRaises(ValueError):
            validate_proposal(result)

    def test_task_rejects_outside_and_configuration_paths(self):
        with tempfile.TemporaryDirectory() as directory:
            task = Path(directory) / "task.json"
            for name in ("../outside.dart", "C:outside.dart", "lib/source.dart:hidden.yaml", ".git/settings.yaml", ".env", "scripts/tool.py"):
                task.write_text(json.dumps({"input_files": [name], "output_files": [], "prompt": "test"}), encoding="utf-8")
                with self.assertRaises(ValueError, msg=name):
                    load_task(task)

    def test_task_rejects_unbounded_resource_limits(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "task.json"
            for settings in ({"timeout_seconds": 0}, {"timeout_seconds": 901},
                             {"budget_usd": 0}, {"budget_usd": 3}, {"budget_usd": float('nan')}):
                path.write_text(json.dumps({"input_files": [], "output_files": ["docs/proposal.md"],
                                            "prompt": "test", **settings}), encoding='utf-8')
                with self.assertRaises(ValueError):
                    load_task(path)

    @unittest.skipUnless(sys.platform == "win32", "Windows job object lifecycle")
    def test_supervisor_exit_kills_worker(self):
        with tempfile.TemporaryDirectory() as directory:
            marker = Path(directory) / "orphan.txt"
            worker = f"import time; from pathlib import Path; time.sleep(2); Path({str(marker)!r}).touch()"
            supervisor = (
                "import os,sys,threading; "
                f"sys.path.insert(0,{str(Path(__file__).parent.resolve())!r}); "
                "from claude_pilot import run_process; "
                "threading.Timer(0.7, lambda: os._exit(9)).start(); "
                f"run_process([sys.executable,'-c',{worker!r}],{str(Path.cwd())!r},30)"
            )
            result = subprocess.run([sys.executable, "-c", supervisor], capture_output=True, timeout=10)
            self.assertEqual(result.returncode, 9)
            subprocess.run([sys.executable, "-c", "import time; time.sleep(2.5)"], check=True)
            self.assertFalse(marker.exists(), "Worker survived supervisor exit")


if __name__ == "__main__":
    unittest.main()
