import 'package:flutter/material.dart';

class CustomDragHandle extends StatelessWidget {
  const CustomDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;

    return Center(
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
