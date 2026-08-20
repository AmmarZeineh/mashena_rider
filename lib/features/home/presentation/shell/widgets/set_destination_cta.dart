import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';

/// Entry CTA for ride requests on the home screen.
///
/// Provides a side-by-side row of actions allowing the rider
/// to choose between a standard private ride or a shared trip.
class SetDestinationCta extends StatelessWidget {
  const SetDestinationCta({
    super.key,
    this.onRequestRide,
    this.onRequestSharedTrip,
  });

  /// Optional callback for standard ride request.
  /// Defaults to [RideFlowCoordinator.openPickAddressAndDrawRoute].
  final VoidCallback? onRequestRide;

  /// Optional callback for shared trip request.
  final VoidCallback? onRequestSharedTrip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Row(
          children: [
            Expanded(
              child: _CtaCardItem(
                icon: Icons.local_taxi_rounded,
                iconColor: colorScheme.primary,
                title: S.of(context).rideRequestRide,
                subtitle: S.of(context).homeWhereTo,
                onTap:
                    onRequestRide ??
                    () => RideFlowCoordinator.openPickAddressAndDrawRoute(
                      context,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CtaCardItem(
                icon: Icons.groups_rounded,
                iconColor: AppColors.shieldGreen,
                title: S.of(context).rideRequestSharedTrip,
                subtitle: S.of(context).rideSharedTripSubtitle,
                onTap:
                    onRequestSharedTrip ??
                    () => context.push(AppRoutes.sharedTripPickAddressPath),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaCardItem extends StatelessWidget {
  const _CtaCardItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              _CtaIcon(icon: icon, iconColor: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaIcon extends StatelessWidget {
  const _CtaIcon({required this.icon, required this.iconColor});

  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}
