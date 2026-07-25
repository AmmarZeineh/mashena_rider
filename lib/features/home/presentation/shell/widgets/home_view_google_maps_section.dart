import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/controllers/app_map_controller.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/infrastructure/flutter_map/flutter_map_widget.dart';
import 'package:mashena_rider/features/home/presentation/shell/cubits/home_cubit/home_cubit.dart';
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
      context.read<HomeCubit>().recheckStatus();
    }
  }

  /// Handles the overlay button tap based on the current permission state.
  // Future<void> _onPermissionOverlayPressed() async {
  //   final cubit = context.read<HomeCubit>();
  //   final locationService = getIt<LocationService>();

  //   if (cubit.state.isDeniedForever) {
  //     await LocationPermissionHelper.showDeniedForeverDialog(
  //       context: context,
  //       locationService: locationService,
  //     );
  //   } else {
  //     final status = await LocationPermissionHelper.showRationaleAndRequest(
  //       context: context,
  //       locationService: locationService,
  //     );
  //     // Update cubit state with the new status.
  //     if (status.isReady) {
  //       cubit.requestPermission();
  //     } else {
  //       cubit.recheckStatus();
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (prev, curr) =>
          prev.position != curr.position ||
          prev.driverLocation != curr.driverLocation ||
          prev.isDriverArrived != curr.isDriverArrived ||
          prev.isTripStarted != curr.isTripStarted,
      listener: (context, state) {
        if (_mapController == null) return;

        if (state.driverLocation != null && state.isDriverFound) {
          final pickup = state.confirmedRideResult?.pickup ??
              (state.matchedTrip != null
                  ? MapLatLng(
                      latitude: state.matchedTrip!.pickupLat,
                      longitude: state.matchedTrip!.pickupLng,
                    )
                  : null);
          final destination = state.confirmedRideResult?.destination ??
              (state.matchedTrip != null
                  ? MapLatLng(
                      latitude: state.matchedTrip!.destinationLat,
                      longitude: state.matchedTrip!.destinationLng,
                    )
                  : null);

          final target = state.isTripStarted
              ? destination
              : pickup;
          if (target != null) {
            _mapController!.fitBounds([state.driverLocation!, target], padding: 80);
            return;
          }
        }

        if (state.position != null && state.driverLocation == null) {
          _mapController!.moveCamera(
            MapLatLng(
              latitude: state.position!.latitude,
              longitude: state.position!.longitude,
            ),
            zoom: 16,
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMapWidget(
                showMyLocation: state.isLocationGranted,
                markers: state.markers,
                polylines: state.polylines,
                initialPosition: const MapLatLng(
                  latitude: 33.5153,
                  longitude: 36.2772,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),

              // Location service turned off
              if (!state.isLocationServiceEnabled)
                Positioned(
                  top: state.isLocationGranted ? 20 : 90,
                  left: 16,
                  right: 16,
                  child: PermissionOverlay(
                    title: S.of(context).locationServiceOffTitle,
                    buttonText: S.of(context).openSettingsButton,
                    onPressed: () =>
                        context.read<HomeCubit>().openLocationSettings(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
