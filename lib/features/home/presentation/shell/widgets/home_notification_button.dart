import 'package:flutter/material.dart';
import 'package:mashena_rider/features/notifications/presentation/views/notifications_view.dart';

class HomeNotificationButton extends StatelessWidget {
  const HomeNotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 20,
      end: 24,
      child: SafeArea(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsView()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
