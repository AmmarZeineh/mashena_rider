import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mashena_rider/features/home/presentation/cubits/home_location_cubit/home_location_cubit.dart';
import 'package:mashena_rider/features/home/presentation/widgets/permission_overlay.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
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
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.ui == HomeUiState.ready &&
            state.position != null &&
            _mapController != null) {
          final p = state.position!;
          _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(p.latitude, p.longitude), 16),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            GoogleMap(
              
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.5153, 36.2772), // fallback
                zoom: 14,
              ),
              onMapCreated: (c) => _mapController = c,
              myLocationEnabled: state.ui == HomeUiState.ready,
              myLocationButtonEnabled: state.ui == HomeUiState.ready,
            ),

            if (state.ui == HomeUiState.permissionNeeded)
              PermissionOverlay(
                title: 'بدنا إذن الموقع',
                buttonText: 'اعطاء صلاحية',
                onPressed: () => context.read<HomeCubit>().requestPermission(),
              ),

            if (state.ui == HomeUiState.permissionPermanentlyDenied)
              PermissionOverlay(
                title: 'الصلاحية مرفوضة نهائيًا',
                buttonText: 'افتح الإعدادات',
                onPressed: () => context.read<HomeCubit>().openSettings(),
              ),

            if (state.ui == HomeUiState.locationServiceOff)
              PermissionOverlay(
                title: 'خدمة الموقع مطفّية',
                buttonText: 'تفعيل الموقع',
                onPressed: () =>
                    context.read<HomeCubit>().openLocationSettings(),
              ),
          ],
        );
      },
    );
  }
}
