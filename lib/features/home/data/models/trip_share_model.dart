import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mashena_rider/features/home/domain/entities/trip_share.dart';

part 'trip_share_model.freezed.dart';
part 'trip_share_model.g.dart';

@freezed
abstract class TripShareModel with _$TripShareModel {
  const TripShareModel._();

  const factory TripShareModel({
    required int shareId,
    required String shareUrl,
    required String status,
    String? expiresAt,
  }) = _TripShareModel;

  factory TripShareModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    return _$TripShareModelFromJson(data);
  }

  TripShare toEntity() {
    return TripShare(
      shareId: shareId,
      shareUrl: shareUrl,
      status: status,
      expiresAt: expiresAt,
    );
  }
}
