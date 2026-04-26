import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/features/home/presentation/cubits/pick_address_cubit/pick_address_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_address_view_body.dart';

import 'package:mashena_rider/features/home/presentation/models/confirmed_ride_flow_result.dart';

class PickAddressView extends StatelessWidget {
  const PickAddressView({super.key, this.initialData});

  final ConfirmedRideFlowResult? initialData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (_) => getIt<PickAddressCubit>()..initialize(initialData),
          child: const PickAddressViewBody(),
        ),
      ),
    );
  }
}

