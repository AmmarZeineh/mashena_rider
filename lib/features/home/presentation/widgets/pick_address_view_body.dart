import 'package:flutter/material.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/widgets/custom_header_button.dart';
import 'package:mashena_rider/features/home/presentation/models/stop_input_model.dart';
import 'package:mashena_rider/features/home/presentation/widgets/custom_divider.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_circular_container.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_form_field.dart';
import 'package:mashena_rider/features/home/presentation/widgets/pick_location_row.dart';
import 'package:mashena_rider/features/home/presentation/widgets/recent_address_tile_widget.dart';
import 'package:mashena_rider/features/home/presentation/widgets/saved_place_widget.dart';

class PickAddressViewBody extends StatefulWidget {
  const PickAddressViewBody({super.key});

  @override
  State<PickAddressViewBody> createState() => _PickAddressViewBodyState();
}

class _PickAddressViewBodyState extends State<PickAddressViewBody> {
  final List<StopInputModel> _stops = [];

  @override
  void initState() {
    super.initState();
    _stops.add(StopInputModel()); // أول stop
  }

  void _addStop() {
    setState(() {
      _stops.add(StopInputModel());
    });
  }

  void _removeStop(int index) {
    _stops[index].dispose();
    setState(() {
      _stops.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (final stop in _stops) {
      stop.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          /// 🔹 Top Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderButton(),
                const SizedBox(height: 16),

                PickLocationRow(
                  address: 'Neemuch RD. Gopalbari, Bari Sad',
                  isActive: true,
                ),

                const SizedBox(height: 12),

                /// Dynamic Stops
                ..._stops.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stop = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        PickLocationCircularContainer(isActive: false),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PickLocationFormField(
                            controller: stop.controller,
                            focusNode: stop.focusNode,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_stops.length > 1)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => _removeStop(index),
                          ),
                      ],
                    ),
                  );
                }),

                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addStop,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Now you can add multiple stops",
                  style: AppTextStyles.w400_12.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const CustomDivider(),
          const SizedBox(height: 16),

          /// 🔹 Saved + Recent
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: const [
                SavedPlaceTile(
                  title: "Home",
                  subtitle: "Neemuch RD. Gopalbari, Bari Sadri Rajasthan",
                ),
                SizedBox(height: 16),
                SavedPlaceTile(
                  title: "Work",
                  subtitle: "Jawahar Lal Nehru Marg, D-Block",
                ),
                SizedBox(height: 24),
                RecentTile("250 west, industrial area"),
                RecentTile("4 number gali pratap nagar"),
                RecentTile("Neemuch RD. Gopalbari, Bari Sad"),
                RecentTile("Jawahar Lal Nehru Marg, D-Block"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
