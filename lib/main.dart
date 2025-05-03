import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const PomodoroHomePage(),
    );
  }
}

class PomodoroHomePage extends StatefulWidget {
  const PomodoroHomePage({super.key});

  @override
  State<PomodoroHomePage> createState() => _PomodoroHomePageState();
}

class _PomodoroHomePageState extends State<PomodoroHomePage> {
  static const int totalTime = 25 * 60; // 25 dakika = 1500 saniye
  int remainingTime = totalTime;
  Timer? timer;
  bool isRunning = false;

  void _startTimer() {
    if (isRunning) return;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          t.cancel();
          isRunning = false;
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void _pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (remainingTime / totalTime);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 250,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                backgroundColor: Colors.grey.shade300,
                color: Colors.deepPurple,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(remainingTime),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
