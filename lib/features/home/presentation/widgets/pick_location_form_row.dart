import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_circular_container.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_form_field.dart';

class PickLocationFormRow extends StatelessWidget {
  const PickLocationFormRow({
    super.key,
    required this.isActive,
    required this.controller,
    required this.focusNode,
  });

  final bool isActive;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PickLocationCircularContainer(isActive: isActive),
        const SizedBox(width: 16),
        Expanded(
          child: PickLocationFormField(
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
