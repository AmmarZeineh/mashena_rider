import 'package:flutter/material.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';

class PickLocationCircularContainer extends StatelessWidget {
  const PickLocationCircularContainer({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(28),
        border: isActive ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Align(
        alignment: isActive ? Alignment.bottomCenter : Alignment.topCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 8.5,
          height: 8.5,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
