import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/home/presentation/common/models/confirmed_ride_flow_result.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/pick_shared_trip_address_cubit/pick_shared_trip_address_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/pick_shared_trip_address_view_body.dart';

class PickSharedTripAddressView extends StatelessWidget {
  const PickSharedTripAddressView({
    super.key,
    this.initialData,
    this.initialLocations,
  });

  final ConfirmedRideFlowResult? initialData;
  final SharedTripRoomsArgs? initialLocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => getIt<PickSharedTripAddressCubit>()
            ..initialize(
              initialData: initialData,
              initialLocations: initialLocations,
            ),
          child: PickSharedTripAddressViewBody(
            isEditing: initialLocations != null,
          ),
        ),
      ),
    );
  }
}
