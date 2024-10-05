import 'package:flutter/material.dart';

class AdPreferencesTile extends StatelessWidget {
  final bool showAds;
  final Function(bool) onToggleAds;

  const AdPreferencesTile({super.key, required this.showAds, required this.onToggleAds});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info, color: Theme.of(context).primaryColor),
          title: const Text(
            'Ad Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Customize how and where ads appear to support the app.\n'
                'Only if enough users enable ads, they can stay optional!',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          trailing: IconButton(
            icon: Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
            tooltip: 'Why should I enable ads?',
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ),
        SwitchListTile(
          title: const Text('Show Ads'),
          value: showAds,
          onChanged: (bool value) {
            onToggleAds(value);
          },
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Support Us by Enabling Ads'),
          content: const Text(
            'I don\'t really make much money writing apps like this, but I enjoy developing useful tools for people. '
                'By keeping ads activated, you help me cover some of the costs and motivate me to keep improving and creating more projects like this one. '
                'Your support means a lot, and it helps ensure that I can continue to have the freedom and will to develop apps that make a difference.',
          ),
          actions: [
            TextButton(
              child: const Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
