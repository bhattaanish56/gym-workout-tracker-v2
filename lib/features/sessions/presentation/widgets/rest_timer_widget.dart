import 'package:flutter/material.dart';
import 'rest_timer_notifier.dart';

class RestTimerWidget extends StatelessWidget {
  final RestTimerNotifier notifier;
  final VoidCallback? onSkip;

  const RestTimerWidget({super.key, required this.notifier, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        if (!notifier.isActive) return const SizedBox.shrink();

        final theme = Theme.of(context);
        final minutes = notifier.remainingSeconds ~/ 60;
        final seconds = notifier.remainingSeconds % 60;

        return Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rest Timer',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        notifier.isRunning ? Icons.pause : Icons.play_arrow,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        if (notifier.isRunning) {
                          notifier.pause();
                        } else {
                          notifier.resume();
                        }
                      },
                      tooltip: notifier.isRunning ? 'Pause' : 'Resume',
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: theme.colorScheme.onPrimaryContainer),
                      onPressed: () => notifier.addTime(15),
                      tooltip: '+15s',
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: theme.colorScheme.onPrimaryContainer),
                      onPressed: () {
                        notifier.skip();
                        onSkip?.call();
                      },
                      tooltip: 'Skip Rest',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
