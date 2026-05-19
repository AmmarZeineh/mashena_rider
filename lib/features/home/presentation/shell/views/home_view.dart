import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/features/home/domain/usecases/submit_ride_request_usecase.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_drawer.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: BlocProvider(
        create: (context) => HomeCubit(
          getIt.get<LocationService>(),
          getIt.get<SubmitRideRequestUsecase>(),
        ),
        child: HomeViewBody(),
      ),
    );
  }
}
