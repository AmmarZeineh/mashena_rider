import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_sizes.dart';
import 'package:mashena_rider/features/home/presentation/widgets/custom_divider.dart';
import 'package:mashena_rider/features/home/presentation/widgets/custom_drag_handle.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_row.dart';

class RequestRideBottomSheet extends StatefulWidget {
  const RequestRideBottomSheet({super.key});

  @override
  State<RequestRideBottomSheet> createState() => _RequestRideBottomSheetState();
}

class _RequestRideBottomSheetState extends State<RequestRideBottomSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  void _openPickAddress(BuildContext context) {
    context.push(AppRoutes.pickAdressPath);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent > AppSizes.minBottomSheetSnapSized) {
          _openPickAddress(context);

          _controller.jumpTo(AppSizes.minBottomSheetSnapSized);

          return true;
        }

        return false;
      },
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: AppSizes.minBottomSheetSnapSized,
        minChildSize: AppSizes.minBottomSheetSnapSized,
        maxChildSize: AppSizes.maxBottomSheetSnapSized,
        snap: true,
        snapSizes: [
          AppSizes.minBottomSheetSnapSized,
          AppSizes.maxBottomSheetSnapSized,
        ],
        builder: (context, scrollController) {
          return GestureDetector(
            onTap: () {
              _openPickAddress(context);
            },
            child: Material(
              elevation: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 12),
                    CustomDragHandle(),
                    const SizedBox(height: 20),
                    Text(
                      'Where do you want to go?',
                      style: AppTextStyles.w500_20,
                    ),
                    const SizedBox(height: 20),
                    PickLocationRow(
                      address: 'Neemuch RD. Gopalbari, Bari Sad',
                      isActive: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        left: 40,
                        bottom: 12,
                      ),
                      child: CustomDivider(),
                    ),
                    const PickLocationRow(isActive: false),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
