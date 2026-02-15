import 'package:flutter/material.dart';

class StopInputModel {
  StopInputModel()
    : controller = TextEditingController(),
      focusNode = FocusNode();

  final TextEditingController controller;
  final FocusNode focusNode;

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}
