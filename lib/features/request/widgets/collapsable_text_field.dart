import 'package:flutter/material.dart';

class CollapsableTextField extends StatelessWidget {
  const CollapsableTextField({
    super.key,
    required this.title,
    required this.onChanged,
  });

  final String title;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: Text(title),
    children: [TextField(maxLines: null, onChanged: onChanged)],
  );
}
