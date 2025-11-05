import 'package:flutter/material.dart';

class TextSearchBar extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const TextSearchBar({
    required this.label,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(7),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
