import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/ride_flow/ride_flow_coordinator.dart';

/// Entry CTA for the address picker flow.
///
/// This replaces the old draggable "where to" sheet.
class SetDestinationCta extends StatelessWidget {
  const SetDestinationCta({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(22),
          color: colorScheme.surface,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () =>
                RideFlowCoordinator.openPickAddressAndDrawRoute(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: _CtaContentRow(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CtaContentRow extends StatelessWidget {
  const _CtaContentRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _CtaIcon(),
        SizedBox(width: 12),
        Expanded(child: _CtaText()),
        _CtaArrow(),
      ],
    );
  }
}

class _CtaIcon extends StatelessWidget {
  const _CtaIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.local_taxi_rounded, color: colorScheme.onPrimary),
    );
  }
}

class _CtaText extends StatelessWidget {
  const _CtaText();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).rideRequestRide,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          S.of(context).homeWhereTo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CtaArrow extends StatelessWidget {
  const _CtaArrow();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}
