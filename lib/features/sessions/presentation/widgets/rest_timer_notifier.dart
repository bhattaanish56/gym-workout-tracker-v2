import 'dart:async';
import 'package:flutter/material.dart';

class RestTimerNotifier extends ChangeNotifier {
  Timer? _timer;
  DateTime? _endTime;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isActive => _endTime != null;

  void start(int durationSeconds) {
    _timer?.cancel();
    _endTime = DateTime.now().add(Duration(seconds: durationSeconds));
    _remainingSeconds = durationSeconds;
    _isRunning = true;
    _startTicking();
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_endTime == null) return;
    _isRunning = true;
    _startTicking();
    notifyListeners();
  }

  void skip() {
    _timer?.cancel();
    _endTime = null;
    _remainingSeconds = 0;
    _isRunning = false;
    notifyListeners();
  }

  void addTime(int seconds) {
    if (_endTime == null) return;
    _endTime = _endTime!.add(Duration(seconds: seconds));
    _updateRemaining();
    notifyListeners();
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _updateRemaining();
      if (_remainingSeconds <= 0) {
        _timer?.cancel();
        _endTime = null;
        _isRunning = false;
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
  }

  void _updateRemaining() {
    if (_endTime == null) {
      _remainingSeconds = 0;
      return;
    }
    final now = DateTime.now();
    final diff = _endTime!.difference(now);
    _remainingSeconds = diff.inSeconds.clamp(0, 999999);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
