"""Local controller checks; never invokes Claude or a network provider."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from claude_pilot import redact, run_process, validate_proposal, validate_response


class PilotTests(unittest.TestCase):
    def test_success(self):
        result = run_process([sys.executable, "-c", "print('ok')"], Path.cwd(), 5)
        self.assertEqual(result["exit_code"], 0)
        self.assertFalse(result["timed_out"])
        self.assertEqual(result["stdout"].strip(), "ok")

    def test_failed_command(self):
        result = run_process([sys.executable, "-c", "raise SystemExit(7)"], Path.cwd(), 5)
        self.assertEqual(result["exit_code"], 7)

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
        for payload in (json.dumps(proposal), "<thinking>provider prefix</thinking>\n" + json.dumps(proposal)):
            result = {"timed_out": False, "exit_code": 0, "stdout": json.dumps({
                "subtype": "success", "is_error": False, "result": payload})}
            self.assertEqual(validate_proposal(result), proposal)
        result["stdout"] = json.dumps({"subtype": "success", "is_error": False,
                                       "result": "arbitrary prose " + json.dumps(proposal)})
        with self.assertRaises(ValueError):
            validate_proposal(result)


if __name__ == "__main__":
    unittest.main()
