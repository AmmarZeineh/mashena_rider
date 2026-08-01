import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/controllers/app_map_controller.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/infrastructure/flutter_map/flutter_map_widget.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/location_cubit/location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/map_state_cubit/map_state_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/driver_tracking_cubit/driver_tracking_cubit.dart';
import 'package:mashena_rider/features/home/presentation/trip/cubits/trip_lifecycle_cubit/trip_lifecycle_cubit.dart';
import 'package:mashena_rider/features/home/presentation/shell/widgets/permission_overlay.dart';

class HomeViewGoogleMapsSection extends StatefulWidget {
  const HomeViewGoogleMapsSection({super.key});

  @override
  State<HomeViewGoogleMapsSection> createState() =>
      _HomeViewGoogleMapsSectionState();
}

class _HomeViewGoogleMapsSectionState extends State<HomeViewGoogleMapsSection>
    with WidgetsBindingObserver {
  AppMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-check permission when the app comes back from settings.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<LocationCubit>().recheckStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Orchestrate driver tracking based on trip lifecycle
        BlocListener<TripLifecycleCubit, TripLifecycleState>(
          listenWhen: (prev, curr) =>
              prev.matchedTrip != curr.matchedTrip ||
              prev.isDriverArrived != curr.isDriverArrived ||
              prev.isTripStarted != curr.isTripStarted ||
              prev.isTripEnded != curr.isTripEnded ||
              prev.tripError != curr.tripError,
          listener: (context, state) {
            final trackingCubit = context.read<DriverTrackingCubit>();
            
            // Restore driver tracking if trip is restored (e.g. app restart)
            if (state.matchedTrip != null && !trackingCubit.state.isTracking) {
              trackingCubit.startTracking(
                pickup: MapLatLng(
                  latitude: state.matchedTrip!.pickupLat,
                  longitude: state.matchedTrip!.pickupLng,
                ),
                destination: MapLatLng(
                  latitude: state.matchedTrip!.destinationLat,
                  longitude: state.matchedTrip!.destinationLng,
                ),
              );
            }
            
            if (state.isDriverArrived) {
              trackingCubit.onDriverArrived();
            }
            
            if (state.isTripStarted && state.matchedTrip != null) {
              trackingCubit.onTripStarted(
                destination: MapLatLng(
                  latitude: state.matchedTrip!.destinationLat,
                  longitude: state.matchedTrip!.destinationLng,
                ),
              );
            }
            
            if (state.isTripEnded || state.tripError != null) {
              trackingCubit.stopTracking();
            }
          },
        ),
        // Driver Tracking Bounds
        BlocListener<DriverTrackingCubit, DriverTrackingState>(
          listenWhen: (prev, curr) =>
              prev.driverLocation != curr.driverLocation ||
              prev.isDriverArrived != curr.isDriverArrived ||
              prev.isTripStarted != curr.isTripStarted,
          listener: (context, state) {
            if (_mapController == null) return;
            
            if (state.driverLocation != null && state.pickup != null && state.destination != null) {
              final target = state.isTripStarted ? state.destination! : state.pickup!;
              _mapController!.fitBounds([state.driverLocation!, target], padding: 80);
            }
          },
        ),
        // My Location Camera Move
        BlocListener<LocationCubit, LocationState>(
          listenWhen: (prev, curr) => prev.position != curr.position,
          listener: (context, state) {
            if (_mapController == null) return;
            
            final isTrackingDriver = context.read<DriverTrackingCubit>().state.driverLocation != null;
            if (state.position != null && !isTrackingDriver) {
              _mapController!.moveCamera(
                MapLatLng(
                  latitude: state.position!.latitude,
                  longitude: state.position!.longitude,
                ),
                zoom: 16,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<MapStateCubit, MapStateState>(
        builder: (context, mapState) {
          return BlocBuilder<LocationCubit, LocationState>(
            builder: (context, locationState) {
              return Stack(
                children: [
                  FlutterMapWidget(
                    showMyLocation: locationState.isGranted,
                    markers: mapState.markers,
                    polylines: mapState.polylines,
                    initialPosition: const MapLatLng(
                      latitude: 33.5153,
                      longitude: 36.2772,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),

                  // Location service turned off
                  if (!locationState.isServiceEnabled)
                    Positioned(
                      top: locationState.isGranted ? 20 : 90,
                      left: 16,
                      right: 16,
                      child: PermissionOverlay(
                        title: S.of(context).locationServiceOffTitle,
                        buttonText: S.of(context).openSettingsButton,
                        onPressed: () =>
                            context.read<LocationCubit>().openLocationSettings(),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
