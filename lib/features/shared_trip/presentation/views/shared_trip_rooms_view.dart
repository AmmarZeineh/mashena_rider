import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/shared_trip/presentation/cubits/shared_trip_rooms_cubit/shared_trip_rooms_cubit.dart';
import 'package:mashena_rider/features/shared_trip/presentation/models/shared_trip_rooms_args.dart';
import 'package:mashena_rider/features/shared_trip/presentation/widgets/shared_trip_rooms_view_body.dart';

class SharedTripRoomsView extends StatelessWidget {
  const SharedTripRoomsView({super.key, required this.args});

  final SharedTripRoomsArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SharedTripRoomsCubit>(param1: args)..searchRooms(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).sharedTripAvailableRooms),
          centerTitle: true,
          elevation: 0,
        ),
        body: const SafeArea(child: SharedTripRoomsViewBody()),
      ),
    );
  }
}
