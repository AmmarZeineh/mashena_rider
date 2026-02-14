import 'package:flutter/material.dart';
import 'package:mashena_rider/features/home/presentation/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/widgets/request_ride_bottom_sheet.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [HomeViewGoogleMapsSection(), RequestRideBottomSheet()],
    );
  }
}
