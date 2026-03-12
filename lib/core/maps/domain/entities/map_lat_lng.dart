import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class MapLatLng extends Equatable {
  final double latitude;
  final double longitude;

  const MapLatLng({required this.latitude, required this.longitude});

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
