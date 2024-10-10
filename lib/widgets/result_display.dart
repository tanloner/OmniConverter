// lib/widgets/result_display.dart
import 'package:flutter/material.dart';

class ResultDisplay extends StatelessWidget {
  final String result;

  const ResultDisplay({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: result.isEmpty
            ? Text(
          'Your results will appear here.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
            fontStyle: FontStyle.italic,
          ),
        )
            : Text(
          result,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
