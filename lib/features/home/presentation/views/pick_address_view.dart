import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_address_view_body.dart';

class PickAddressView extends StatelessWidget {
  const PickAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: PickAddressViewBody()));
  }
}
