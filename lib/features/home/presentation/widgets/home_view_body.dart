import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/car_type_bottom_sheet.dart';
import 'package:mashena_rider/features/home/presentation/widgets/home_view_google_maps_section.dart';
import 'package:mashena_rider/features/home/presentation/widgets/set_destination_cta.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final rideResult = state.confirmedRideResult;
        return Stack(
          children: [
            const HomeViewGoogleMapsSection(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              child: rideResult == null
                  ? const Align(
                      key: ValueKey('cta'),
                      alignment: Alignment.bottomCenter,
                      child: SetDestinationCta(),
                    )
                  : Align(
                      key: const ValueKey('sheet'),
                      alignment: Alignment.bottomCenter,
                      child: CarTypeBottomSheet(
                        estimateResponse: rideResult.estimateResponse,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
