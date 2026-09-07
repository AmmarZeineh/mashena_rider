import '../../domain/entities/ride_estimate.dart';
import '../models/ride_estimate_model.dart';

extension RideEstimateModelMapper on RideEstimateModel {
  RideEstimate toEntity() {
    return RideEstimate(
      vehicleTypeId: vehicleTypeId,
      name: name,
      imageUrl: imageUrl,
      currency: currency,
      estimatedFare: estimatedFare,
      originalFare: originalFare,
      discountAmount: discountAmount,
      finalFare: finalFare,
      appliedCoupon: appliedCoupon?.toEntity(),
    );
  }
}
