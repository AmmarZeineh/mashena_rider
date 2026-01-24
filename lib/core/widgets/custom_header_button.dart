import 'package:flutter/material.dart';

class CustomHeaderButton extends StatelessWidget {
  const CustomHeaderButton({
    super.key,
    this.onPressed,
    this.size = 56.0,
    this.iconSize = 32.0,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.iconData = Icons.chevron_left,
  });

  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: IconButton(
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
        icon: Icon(iconData, size: iconSize, color: iconColor ?? Colors.black),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
