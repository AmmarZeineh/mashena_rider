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

  // Shared Rides
  static const String searchSharedRides = '/shared-rides/search';
  static String getSharedRideDetails(int id) => '/shared-rides/$id';
  static String joinSharedRide(int id) => '/shared-rides/$id/join';
  static String leaveSharedRide(int id) => '/shared-rides/$id/leave';

  // Passenger Pools
  static const String poolSuggestions = '/passenger-pools/suggestions';
  static const String createPoolRoom = '/passenger-pools';
  static String getPoolRoomDetails(int id) => '/passenger-pools/$id';
  static String joinPoolRoom(int id) => '/passenger-pools/$id/join';
  static String leavePoolRoom(int id) => '/passenger-pools/$id/leave';
  static String cancelPoolRoom(int id) => '/passenger-pools/$id';

  // Coupons
  static const String activateCoupon = '/coupons/activate';
  static const String myCoupons = '/coupons/my-coupons';
  static const String myCouponHistory = '/coupons/my-history';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationToken = '/notifications/token';
  static String markNotificationRead(int id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/read-all';

  // Moderation
  static const String moderationOverview = '/me/moderation';
  static const String myPenalties = '/me/penalties';
  static const String myViolations = '/me/violations';
  static const String myRestrictions = '/me/restrictions';
  static String appealPenalty(int id) => '/me/penalties/$id/appeal';
  static const String myAppeals = '/me/appeals';
  static String appealDetails(int id) => '/me/appeals/$id';

  // External APIs
  static const String nominatimSearch =
      'https://nominatim.openstreetmap.org/search';
  static const String nominatimReverse =
      'https://nominatim.openstreetmap.org/reverse';
  static const String nominatimCountryCodes = 'sy';
}
