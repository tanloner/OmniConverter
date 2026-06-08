import 'package:flutter/material.dart';

class Impressum extends StatelessWidget {
  const Impressum ({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
          title: const Text('Impressum'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {_showImpressumDialog(context);},
      ),);
  }
  
  void _showImpressumDialog(BuildContext context){
    showDialog(context: context, builder: (BuildContext context) {return AboutDialog(
      applicationName: 'OmniConverter',
      applicationVersion: '0.3.4',
      applicationIcon: Icon(Icons.apps, size: 50),
      applicationLegalese: '© 2026 Extensos GmbH\n'
        'Quirin Stetten\n'
        'Ziegelhofstr. 8b 81247 München\n'
        'Email: info@virtelligent.de'
    );});
  }
}