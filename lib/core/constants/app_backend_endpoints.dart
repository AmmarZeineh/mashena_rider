class BackendEndpoints {
  static const String signup = '/user/riders';
  static const String login = '/auth/rider/login';
  static const String sendOtpRider = '/verification-otp/rider/send-otp';
  static const String verifyOtpRider = '/verification-otp/rider/verify-otp';
  static const String createRideRequest = '/ride-requests';
  static const String submitRideRequest = '/ride-requests/submit';
  static const String getMatchedTrip = '/trips/by-ride';
  static const String cancelRideByRider = '/trips/by-ride';
  static String shareTripByRide(int rideRequestId) =>
      '/trips/by-ride/$rideRequestId/share';
  static const String riderTripHistory = '/trips/rider/history';
  static const String refresh = '/auth/refresh';
  static const String ratingTags = '/rating-tags';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout-all';
  static String getSubmitRatingEndpoint(int tripId) => '/trips/$tripId/rate';
  static String riderProfile(int id) => '/user/riders/$id';

  // Coupons
  static const String activateCoupon = '/coupons/activate';
  static const String myCoupons = '/coupons/my-coupons';
  static const String myCouponHistory = '/coupons/my-history';

  // External APIs
  static const String nominatimSearch = 'https://nominatim.openstreetmap.org/search';
  static const String nominatimReverse = 'https://nominatim.openstreetmap.org/reverse';
  static const String nominatimCountryCodes = 'sy';
}

