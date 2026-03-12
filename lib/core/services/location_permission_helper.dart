import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/services/location_service.dart';
import 'package:mashena_rider/core/services/location_status.dart';

/// Shows a localized rationale dialog before triggering the OS permission prompt.
///
/// Best-practice: explain *why* you need the permission before the OS dialog.
/// This improves grant rates and complies with Google Play / App Store guidelines.
class LocationPermissionHelper {
  const LocationPermissionHelper._();

  /// Shows a rationale dialog, then requests permission if the user taps "Allow".
  ///
  /// Returns the resulting [LocationStatus].
  /// If the user dismisses the dialog the permission is *not* requested and
  /// the current status is returned unchanged.
  static Future<LocationStatus> showRationaleAndRequest({
    required BuildContext context,
    required LocationService locationService,
  }) async {
    final currentStatus = await locationService.checkStatus();

    // Already granted — nothing to do.
    if (currentStatus.permission == LocationPermissionState.granted) {
      return currentStatus;
    }

    // Permanently denied — show the "open settings" dialog instead.
    if (currentStatus.permission == LocationPermissionState.deniedForever) {
      if (context.mounted) {
        await showDeniedForeverDialog(
          context: context,
          locationService: locationService,
        );
      }
      // Re-check after the user might have returned from settings.
      return locationService.checkStatus();
    }

    // Show rationale dialog.
    if (!context.mounted) return currentStatus;

    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final s = S.of(dialogContext);
        final theme = Theme.of(dialogContext);
        final cs = theme.colorScheme;

        return AlertDialog(
          backgroundColor: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            s.locationPermissionRationaleTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          content: Text(
            s.locationPermissionRationaleBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                s.commonCancel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: .6),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(s.locationPermissionAllow),
            ),
          ],
        );
      },
    );

    if (shouldRequest == true) {
      return locationService.requestPermissionIfNeeded();
    }

    return currentStatus;
  }

  /// Shows a dialog informing the user that permission is permanently denied
  /// and offers to open the system app settings.
  static Future<void> showDeniedForeverDialog({
    required BuildContext context,
    required LocationService locationService,
  }) async {
    final s = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            s.locationPermissionDeniedForeverTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          content: Text(
            s.locationPermissionDeniedForeverBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                s.commonCancel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.onSurface.withValues(alpha: .6),
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                locationService.openAppSettings();
              },
              child: Text(s.openSettingsButton),
            ),
          ],
        );
      },
    );
  }
}
