import 'package:flutter/material.dart';

class TitledSwitch extends StatelessWidget {
  const TitledSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final bool value;
  final void Function(bool) onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(value: value, onChanged: enabled ? onChanged : null),
      ],
    ),
  );
}
