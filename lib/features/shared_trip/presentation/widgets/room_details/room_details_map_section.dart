import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/maps/infrastructure/flutter_map/flutter_map_widget.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/features/shared_trip/domain/entities/shared_ride_room_details_entity.dart';

class RoomDetailsMapSection extends StatelessWidget {
  final SharedRideRoomDetailsEntity details;
  final MapLatLng? driverLocation;

  const RoomDetailsMapSection({
    super.key,
    required this.details,
    this.driverLocation,
  });

  @override
  Widget build(BuildContext context) {
    final originPos = MapLatLng(
      latitude: details.originLat,
      longitude: details.originLng,
    );
    final destPos = MapLatLng(
      latitude: details.destLat,
      longitude: details.destLng,
    );

    final markers = [
      MapMarker(
        id: 'origin',
        position: originPos,
        iconWidget: Container(
          decoration: BoxDecoration(
            color: AppColors.shieldGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shieldGreen.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.trip_origin_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      MapMarker(
        id: 'destination',
        position: destPos,
        iconWidget: Container(
          decoration: BoxDecoration(
            color: AppColors.errorColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.errorColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      if (driverLocation != null)
        MapMarker(
          id: 'driver_car',
          position: driverLocation!,
          iconWidget: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
    ];

    final polylines = details.routePoints.isNotEmpty
        ? [
            MapPolyline(
              id: 'room_route',
              points: details.routePoints,
              color: AppColors.primaryColor,
              width: 5,
            ),
          ]
        : <MapPolyline>[];

    return Container(
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            FlutterMapWidget(
              initialPosition: driverLocation ?? originPos,
              onMapCreated: (controller) {
                if (driverLocation != null) {
                  controller.moveCamera(driverLocation!, zoom: 15.0);
                } else if (details.routePoints.isNotEmpty) {
                  controller.fitBounds(details.routePoints);
                }
              },
              markers: markers,
              polylines: polylines,
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 14.r,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      details.status,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: details.isOpen
                            ? AppColors.shieldGreen
                            : (details.isInProgress
                                  ? AppColors.primaryColor
                                  : AppColors.textGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
