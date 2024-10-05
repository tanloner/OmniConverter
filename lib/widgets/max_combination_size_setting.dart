import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class MaxCombinationSizeSetting extends StatelessWidget {
  const MaxCombinationSizeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        int maxCombinationSize = settingsProvider.settings.maxCombinationSize;

        if (kDebugMode) {
          print("houston? the answer is $maxCombinationSize");
        }

        return Column(
          children: [
            Text('Max Combination Size: $maxCombinationSize'),
            Slider(
              value: maxCombinationSize.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: maxCombinationSize.toString(),
              onChanged: (value) {
                settingsProvider.updateMaxCombinationSize(value.toInt());
              },
            ),
          ],
        );
      },
    );
  }
}
