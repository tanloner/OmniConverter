import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initiallySelected;
  final String title;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initiallySelected,
    this.title = 'Select Ad Placements',
  });

  @override
  MultiSelectDialogState createState() => MultiSelectDialogState();
}

class MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _tempSelected.contains(item),
            title: Text(item),
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  _tempSelected.add(item);
                } else {
                  _tempSelected.remove(item);
                }
              });
            },
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(_tempSelected),
        ),
      ],
    );
  }
}