import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';

class HomeActiveTripsButton extends StatelessWidget {
  const HomeActiveTripsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return PositionedDirectional(
      top: 20,
      end: 80,
      child: SafeArea(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.push(AppRoutes.activeTripsPath);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Tooltip(
              message: s.activeTripsTitle,
              child: Icon(
                Icons.directions_car_rounded,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
