import 'package:flutter/material.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
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

  bool isExpanded = false;

  void _toggleSheet() {
    final target = isExpanded ? 0.18 : 0.93;

    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.27,
      minChildSize: 0.18,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.18, 0.85],
      builder: (context, scrollController) {
        return Material(
          elevation: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggleSheet,
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
                  SizedBox(height: 20),
                  PickLocationRow(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 40,
                      bottom: 12,
                    ),
                    child: CustomDivider(),
                  ),

                  PickLocationRow(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
