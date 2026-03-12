import 'package:flutter/material.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/infrastructure/flutter_map/flutter_map_widget.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/widgets/custom_elevated_button.dart';

class PickFromMapView extends StatefulWidget {
  const PickFromMapView({super.key, required this.initialLocation});

  final MapLatLng initialLocation;

  @override
  State<PickFromMapView> createState() => _PickFromMapViewState();
}

class _PickFromMapViewState extends State<PickFromMapView> {
  late MapLatLng _currentCenter;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMapWidget(
            initialPosition: widget.initialLocation,
            onMapCreated: (controller) {},
            onCameraMove: (position) {
              if (!_isMoving) {
                setState(() => _isMoving = true);
              }
              _currentCenter = position;
            },
            onCameraIdle: () {
              setState(() => _isMoving = false);
            },
            showMyLocation: true,
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Center Pin Tooltip/Indicator
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  transform: Matrix4.translationValues(
                    0,
                    _isMoving ? -20 : -10,
                    0,
                  ),
                  child: Text(
                    S.of(context).mapDragToMovePin,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(
                    0,
                    _isMoving ? -10 : 0,
                    0,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                    color: AppColors.primaryColor,
                  ),
                ),
                // Offset the pin so it points exactly to the center
                const SizedBox(height: 40),
              ],
            ),
          ),

          // Bottom Confirm Button
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: CustomElevatedButton(
                title: S.of(context).mapConfirmLocation,
                onPressed: () {
                  Navigator.of(context).pop(_currentCenter);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
