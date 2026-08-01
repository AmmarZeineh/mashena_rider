import '../../domain/entities/ride_location.dart';
import '../models/ride_location_model.dart';

extension RideLocationModelMapper on RideLocationModel {
  RideLocation toEntity() => RideLocation(lat: lat, lng: lng, address: address);
}
