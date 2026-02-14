import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/permission_overlay.dart';

class HomeViewGoogleMapsSection extends StatefulWidget {
  const HomeViewGoogleMapsSection({super.key});

  @override
  State<HomeViewGoogleMapsSection> createState() =>
      _HomeViewGoogleMapsSectionState();
}

class _HomeViewGoogleMapsSectionState extends State<HomeViewGoogleMapsSection> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (prev, curr) => prev.position != curr.position,
      listener: (context, state) {
        if (state.position != null && _mapController != null) {
          final p = state.position!;
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(p.latitude, p.longitude), 16),
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(33.5153, 36.2772),
                  zoom: 14,
                ),
                onMapCreated: (c) => _mapController = c,
                myLocationEnabled: state.isLocationGranted,
                myLocationButtonEnabled: state.isLocationGranted,
              ),

              if (!state.isLocationGranted)
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: PermissionOverlay(
                    title: S.of(context).enableLocationBannerTitle,
                    buttonText: S.of(context).enableLocationButton,
                    onPressed: () =>
                        context.read<HomeCubit>().requestPermission(),
                  ),
                ),

              if (!state.isLocationServiceEnabled)
                Positioned(
                  top: 90,
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
