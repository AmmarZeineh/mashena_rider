import 'package:flutter/material.dart';
import 'package:mashena_rider/core/common/extensions/responsive_num_x.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_marker.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_polyline.dart';
import 'package:mashena_rider/core/maps/infrastructure/flutter_map/flutter_map_widget.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import '../../domain/entities/pool_room_entity.dart';

class PoolLobbyMap extends StatelessWidget {
  final PoolRoomEntity room;
  final int? currentUserId;
  final List<MapLatLng> walkingRoutePoints;

  const PoolLobbyMap({
    super.key,
    required this.room,
    this.currentUserId,
    this.walkingRoutePoints = const [],
  });

  @override
  Widget build(BuildContext context) {
    double myPickupLat = room.meetingLat;
    double myPickupLng = room.meetingLng;

    final myMember = room.members
        .where((m) => m.riderProfileId == currentUserId)
        .firstOrNull;
    if (myMember != null) {
      myPickupLat = myMember.pickupLat;
      myPickupLng = myMember.pickupLng;
    }

    final pickupPos = MapLatLng(latitude: myPickupLat, longitude: myPickupLng);
    final meetingPos = MapLatLng(
      latitude: room.meetingLat,
      longitude: room.meetingLng,
    );
    final destPos = MapLatLng(
      latitude: room.destinationLat,
      longitude: room.destinationLng,
    );

    final markers = <MapMarker>[
      // 1. Rider Pickup
      MapMarker(
        id: 'rider_pickup',
        position: pickupPos,
        iconWidget: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.person_pin_circle_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      // 2. Shared Dynamic Meeting Point
      MapMarker(
        id: 'meeting_point',
        position: meetingPos,
        iconWidget: Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.shieldGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shieldGreen.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2.5),
          ),
          child: const Icon(
            Icons.directions_walk_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
      // 3. Destination
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
            size: 22,
          ),
        ),
      ),
    ];

    final polylines = <MapPolyline>[];

    // Walking path from pickup to meeting point
    if (walkingRoutePoints.length >= 2) {
      polylines.add(
        MapPolyline(
          id: 'walking_route',
          points: walkingRoutePoints,
          color: AppColors.shieldGreen,
          width: 4,
        ),
      );
    } else if (pickupPos != meetingPos) {
      polylines.add(
        MapPolyline(
          id: 'walking_route_direct',
          points: [pickupPos, meetingPos],
          color: AppColors.shieldGreen.withValues(alpha: 0.7),
          width: 3,
        ),
      );
    }

    // Main Transit path from meeting point to destination
    polylines.add(
      MapPolyline(
        id: 'main_route',
        points: [meetingPos, destPos],
        color: AppColors.primaryColor,
        width: 4,
      ),
    );

    return FlutterMapWidget(
      initialPosition: meetingPos,
      markers: markers,
      polylines: polylines,
      onMapCreated: (_) {},
    );
  }
}
