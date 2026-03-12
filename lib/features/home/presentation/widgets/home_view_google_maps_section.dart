import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/maps/domain/controllers/app_map_controller.dart';
import 'package:mashena_rider/core/maps/domain/entities/map_lat_lng.dart';
import 'package:mashena_rider/core/maps/infrastructure/google_maps/google_map_widget.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/permission_overlay.dart';

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
      listenWhen: (prev, curr) => prev.position != curr.position,
      listener: (context, state) {
        if (state.position != null && _mapController != null) {
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
              GoogleMapWidget(
                showMyLocation: state.isLocationGranted,
                markers: [],
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
