import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';

import 'found_driver_details.dart';
import 'searching_driver_details.dart';

class DriverCard extends StatelessWidget {
  const DriverCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.isDriverFound != current.isDriverFound,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              ),
            );
          },
          child: state.isDriverFound
              ? const FoundDriverDetails(key: ValueKey('found'))
              : const SearchingDriverDetails(key: ValueKey('searching')),
        );
      },
    );
  }
}
