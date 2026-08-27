// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mashena';

  @override
  String get appDescription => 'Welcome to Mashena';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get enableLocationBannerTitle =>
      'Enable location to detect your pickup point automatically';

  @override
  String get enableLocationButton => 'Enable';

  @override
  String get locationServiceOffTitle => 'Location service is turned off';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSelected => 'Selected';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonRetry => 'Retry';

  @override
  String get onboardingTitle1 => 'Book a Ride Anytime';

  @override
  String get onboardingSubtitle1 =>
      'Find a nearby driver and book your ride in seconds.';

  @override
  String get onboardingTitle2 => 'Track Your Driver Live';

  @override
  String get onboardingSubtitle2 =>
      'See your driver’s location and arrival time in real time.';

  @override
  String get onboardingTitle3 => 'Easy & Secure Payments';

  @override
  String get onboardingSubtitle3 =>
      'Pay cash or online with complete safety and comfort.';

  @override
  String get authLogin => 'Login';

  @override
  String get enterYourNumberLogin => 'Enter your number to login';

  @override
  String get enterYourNumberRegister => 'Enter your number to sign up';

  @override
  String get enterYourEmailLogin => 'Enter your email to login';

  @override
  String get enterYourEmailRegister => 'Enter your email to sign up';

  @override
  String get enterDestination => 'Enter Destination';

  @override
  String get authRegister => 'Create Account';

  @override
  String get authLogout => 'Logout';

  @override
  String get authSendCode => 'Send Code';

  @override
  String get authDontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get authPhone => 'Phone Number';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authOtpTitle => 'Verification Code';

  @override
  String get authOtpSubtitle => 'Enter the code sent to your phone';

  @override
  String get authResendOtp => 'Resend Code';

  @override
  String get authOtpSuccess => 'Verification successful';

  @override
  String get otpResendSuccess => 'Code sent successfully';

  @override
  String get homeWhereTo => 'Where to?';

  @override
  String get homeCurrentLocation => 'Current location';

  @override
  String get homeSearchDestination => 'Search destination';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get makeSureInternetConnection =>
      'Please check your internet connection and try again.';

  @override
  String get rideRequestRide => 'Request Ride';

  @override
  String get rideRequestSharedTrip => 'Shared Trip';

  @override
  String get rideSharedTripSubtitle => 'Share & save';

  @override
  String get sharedTripAvailableRooms => 'Available Shared Trips';

  @override
  String get sharedTripSearchRooms => 'Search';

  @override
  String get sharedTripChangeLocations => 'Change';

  @override
  String get sharedTripPickup => 'Pickup';

  @override
  String get sharedTripDestination => 'Destination';

  @override
  String get sharedTripSearchingRooms =>
      'Searching for available shared trips...';

  @override
  String get sharedTripNoRoomsFound => 'No shared trips found for this route.';

  @override
  String get sharedTripFarePerSeat => 'Fare per seat';

  @override
  String get sharedTripAvailableSeats => 'Available seats';

  @override
  String sharedTripSeatsCount(int available, int total) {
    return '$available of $total seats';
  }

  @override
  String get sharedTripDriver => 'Driver';

  @override
  String get sharedTripVehicle => 'Vehicle';

  @override
  String get sharedTripDepartureTime => 'Departure Time';

  @override
  String sharedTripOriginDistance(String distance) {
    return '$distance km from pickup';
  }

  @override
  String sharedTripDestDistance(String distance) {
    return '$distance km from destination';
  }

  @override
  String get currencySyp => 'SYP';

  @override
  String get sharedTripStatusOpen => 'Available';

  @override
  String get sharedTripRoomDetailsTitle => 'Trip Details';

  @override
  String get sharedTripRouteOverview => 'Route Overview';

  @override
  String get sharedTripTotalDistance => 'Total Distance';

  @override
  String get sharedTripEstDuration => 'Est. Duration';

  @override
  String get sharedTripDriverNotes => 'Driver Notes & Instructions';

  @override
  String get sharedTripOccupancy => 'Seat Occupancy';

  @override
  String sharedTripOccupiedSeats(int count) {
    return '$count occupied';
  }

  @override
  String sharedTripFreeSeats(int count) {
    return '$count available';
  }

  @override
  String get sharedTripFullFare => 'Full Route Fare';

  @override
  String get sharedTripMinFare => 'Minimum Fare';

  @override
  String get sharedTripBaseCost => 'Total Base Fare';

  @override
  String get sharedTripJoinRoom => 'Join Shared Trip';

  @override
  String get sharedTripRoomFull => 'Trip is Full';

  @override
  String get sharedTripRoomClosed => 'Trip is Closed';

  @override
  String get sharedTripPassengers => 'Passengers';

  @override
  String get sharedTripNoNotes => 'No special instructions provided.';

  @override
  String get sharedTripSelectSeatsTitle => 'Select Seats';

  @override
  String get sharedTripSeatsNeeded => 'Seats Needed';

  @override
  String get sharedTripJoinSuccess => 'Joined shared trip successfully!';

  @override
  String get sharedTripArrivedTitle => 'You Have Arrived!';

  @override
  String get sharedTripArrivedSubtitle => 'Hope you enjoyed your shared trip.';

  @override
  String get sharedTripBackToHome => 'Back to Home';

  @override
  String get sharedTripFinalFare => 'Final Fare';

  @override
  String get sharedTripConfirmJoin => 'Confirm & Join';

  @override
  String get sharedTripLeaveRoom => 'Leave Shared Trip';

  @override
  String get sharedTripLeaveConfirmTitle => 'Leave Shared Trip?';

  @override
  String get sharedTripLeaveConfirmBody =>
      'Are you sure you want to leave this shared trip? Your seat will become available for others.';

  @override
  String get sharedTripLeaveSuccess => 'You have left the shared trip.';

  @override
  String sharedTripCompanionDropped(String fare, String currency) {
    return 'A companion has been dropped off. Fare: $fare $currency';
  }

  @override
  String get rideFindingDriver => 'Finding a driver...';

  @override
  String get rideDriverOnWay => 'Driver is on the way';

  @override
  String get rideDriverArrived => 'Driver arrived';

  @override
  String get rideTripStarted => 'Trip started';

  @override
  String get rideTripEnded => 'Trip ended';

  @override
  String get rideCancelRide => 'Cancel Ride';

  @override
  String get rideEstimatedTime => 'Estimated time';

  @override
  String get rideEstimatedPrice => 'Estimated price';

  @override
  String get paymentPaymentMethod => 'Payment Method';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentOnline => 'Online Payment';

  @override
  String get paymentTotal => 'Total';

  @override
  String get paymentPayNow => 'Pay Now';

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get paymentFailed => 'Payment failed';

  @override
  String get ratingRateDriver => 'Rate Driver';

  @override
  String get ratingLeaveComment => 'Leave a comment (optional)';

  @override
  String get ratingSubmitRating => 'Submit Rating';

  @override
  String get profileProfile => 'Profile';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileName => 'Name';

  @override
  String get email => 'Email';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get settingsSettings => 'Settings';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsChangeLanguage => 'Change Language';

  @override
  String get settingsAboutApp => 'About App';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSubtitle => 'Choose how Mashena Rider looks to you';

  @override
  String get settingsThemeSystem => 'System Default';

  @override
  String get settingsThemeSystemDesc => 'Match your device system settings';

  @override
  String get settingsThemeLight => 'Light Mode';

  @override
  String get settingsThemeLightDesc =>
      'Classic bright look with optimal clarity';

  @override
  String get settingsThemeDark => 'Dark Mode';

  @override
  String get settingsThemeDarkDesc =>
      'Easy on the eyes in low-light conditions';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle =>
      'Select your preferred application language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageArabic => 'العربية (Arabic)';

  @override
  String get settingsAppInfo => 'App Information';

  @override
  String get settingsAppVersion => 'Version 1.0.0';

  @override
  String get settingsAppDescription =>
      'Mashena Rider - Safe, reliable and comfortable rides';

  @override
  String get errorsNetwork => 'Check your internet connection';

  @override
  String get errorsUnauthorized => 'Unauthorized access';

  @override
  String get errorsLocationPermission => 'Please allow location access';

  @override
  String get apiConnectionTimeout => 'Connection timeout';

  @override
  String get apiSendTimeout => 'Send timeout';

  @override
  String get apiReceiveTimeout => 'Receive timeout';

  @override
  String get apiRequestCancelled => 'Request cancelled';

  @override
  String get apiConnectionError => 'Connection error';

  @override
  String get apiCertificateError => 'Certificate error';

  @override
  String get apiBadRequest => 'Bad request';

  @override
  String get apiUnauthorized => 'Unauthorized';

  @override
  String get apiForbidden => 'Forbidden';

  @override
  String get apiNotFound => 'Not found';

  @override
  String get apiValidationError => 'Validation error';

  @override
  String get apiServerError => 'Server error';

  @override
  String get apiBadGateway => 'Bad gateway';

  @override
  String get apiServiceUnavailable => 'Service unavailable';

  @override
  String apiRequestFailed(Object code) {
    return 'Request failed ($code)';
  }

  @override
  String get otpTitle => 'Enter verification code';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String otpSubtitle(Object phone) {
    return 'A code has been sent to $phone';
  }

  @override
  String get otpDidNotReceive => 'Don\'t receive a code?';

  @override
  String get otpResend => 'Resend';

  @override
  String get otpVerifyNow => 'Verify Now';

  @override
  String get apiUnknownError => 'Unknown error';

  @override
  String get cacheError => 'Cache error';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationInvalidEmail => 'Invalid email';

  @override
  String get validationInvalidPhone => 'Invalid phone number';

  @override
  String get validationWeakPassword =>
      'Weak password (uppercase, lowercase, number, symbol)';

  @override
  String get validationOtpInvalid => 'Invalid code';

  @override
  String validationMinLength(int min) {
    return 'Minimum $min characters';
  }

  @override
  String get validationPasswordsNotMatch => 'Passwords do not match';

  @override
  String validationMaxLength(int max) {
    return 'Maximum $max characters';
  }

  @override
  String get locationPermissionRationaleTitle => 'Location Access';

  @override
  String get locationPermissionRationaleBody =>
      'Mashena needs your location to show your position on the map, auto-detect your pickup point, and connect you with nearby drivers.';

  @override
  String get locationPermissionAllow => 'Allow';

  @override
  String get locationPermissionDeniedForeverTitle =>
      'Location Permission Required';

  @override
  String get locationPermissionDeniedForeverBody =>
      'You have permanently denied location access. Please open Settings and enable it manually.';

  @override
  String get mapDragToMovePin => 'Drag map to move pin';

  @override
  String get mapConfirmLocation => 'Confirm Location';

  @override
  String get homeNowYouCanAddMultipleStops => 'Now you can add multiple stops';

  @override
  String get rideAvailableRides => 'Available Rides';

  @override
  String get rideBookRide => 'Book Ride';

  @override
  String get rideNoTypesAvailable =>
      'No ride types available for this trip right now.';

  @override
  String rideDistanceKm(String distance) {
    return '$distance km';
  }

  @override
  String rideDurationMin(String duration) {
    return '$duration min';
  }

  @override
  String rideStopsCount(int count) {
    return '$count stop(s)';
  }

  @override
  String get ridePersonCapacity => '4+1 Person';

  @override
  String get homeMapRouteUnavailable =>
      'Map route currently unavailable. Markers show your trip stops.';

  @override
  String get rideConfirmed => 'Ride Confirmed';

  @override
  String get driverRating => 'Rating';

  @override
  String get driverTrips => 'Trips';

  @override
  String get driverYears => 'Years';

  @override
  String get driverVehicleDetails => 'Vehicle Details';

  @override
  String get driverLicensePlate => 'License Plate';

  @override
  String get commonClose => 'Close';

  @override
  String get rideEstFare => 'Est. Fare';

  @override
  String get rideDistance => 'Distance';

  @override
  String get rideDuration => 'Duration';

  @override
  String get commonPleaseWait => 'Please wait';

  @override
  String get rideLookingForDrivers => 'Looking for nearby drivers...';

  @override
  String get rideTakesFewMoments => 'This usually takes a few moments';

  @override
  String get simulateEndTrip => 'Simulate End Trip';

  @override
  String get tripCancelledByDriver => 'Trip cancelled by driver';

  @override
  String get tripCancelledByAdmin => 'Trip cancelled by admin';

  @override
  String get tripCancelled => 'Trip cancelled';

  @override
  String get tripCancelledSubtitleDriver =>
      'Your driver cancelled the ride request. You can request a new ride anytime.';

  @override
  String get tripCancelledSubtitleAdmin =>
      'The ride was cancelled by the system administrator.';

  @override
  String get tripCancelledSubtitleGeneral =>
      'Your trip request has been cancelled.';

  @override
  String get noCancellationFeeNotice =>
      'No cancellation fee was charged for this ride.';

  @override
  String get logoutConfirmationMessage =>
      'Do you want to logout from this device or all devices?';

  @override
  String get logoutThisDevice => 'This Device';

  @override
  String get logoutAllDevices => 'All Devices';

  @override
  String get drawerMyAccount => 'My Account';

  @override
  String get drawerFavourites => 'Favourites';

  @override
  String get drawerFaq => 'FAQ';

  @override
  String get drawerSos => 'SOS';

  @override
  String get drawerMakeComplaints => 'Make Complaints';

  @override
  String get drawerNotification => 'Notification';

  @override
  String get drawerAbout => 'About';

  @override
  String get drawerPrivacyPolicy => 'Privacy Policy';

  @override
  String get drawerTermsCondition => 'Terms & Condition';

  @override
  String get drawerGuestUser => 'Guest User';

  @override
  String get rideLoadingDriverDetails => 'Loading driver details...';

  @override
  String rideVehicleModelAndColor(String vehicleModel, String vehicleColor) {
    return '$vehicleModel • $vehicleColor';
  }

  @override
  String get rideDriverArrivedAtPickup =>
      'Your driver has arrived at the pickup location!';

  @override
  String get rideWaitingChargesWarning =>
      '⚠️ Waiting charges may apply after the free wait timer expires.';

  @override
  String get rideInProgressHeadingToDestination =>
      'In Progress • Heading to Destination';

  @override
  String get rideWaitingChargesApplying =>
      '⏱️ 00:00 • Waiting charges are now applying';

  @override
  String rideFreeWaitingTime(String minutes, String seconds) {
    return '⏱️ Free waiting time: $minutes:$seconds';
  }

  @override
  String get rideVehicleDefault => 'Vehicle';

  @override
  String get rideVehicleStandard => 'Standard';

  @override
  String rideVehicleColorAndType(String color, String type) {
    return '$color • $type';
  }

  @override
  String get drawerCoupons => 'Coupons';

  @override
  String get applyCouponTitle => 'Apply Coupon';

  @override
  String get enterCouponHint => 'Enter coupon code';

  @override
  String get applyButton => 'Apply';

  @override
  String get activeCouponsSection => 'Active Coupons';

  @override
  String get couponHistorySection => 'Coupon History';

  @override
  String get noActiveCoupons => 'No active coupons available';

  @override
  String get noCouponHistory => 'No coupon history found';

  @override
  String remainingUsages(num count) {
    return '$count usages remaining';
  }

  @override
  String get couponStatusActive => 'Active';

  @override
  String get couponStatusUsed => 'Used';

  @override
  String get couponStatusExpired => 'Expired';

  @override
  String expiresOn(String date) {
    return 'Expires on $date';
  }

  @override
  String get couponAppliedSuccess => 'Coupon applied successfully';

  @override
  String get enterValidCouponCode => 'Please enter a coupon code';

  @override
  String get couponOriginalFare => 'Original Fare';

  @override
  String get couponSaved => 'Saved';

  @override
  String get couponFinalFare => 'Final Fare';

  @override
  String get appCurrency => 'SYP';

  @override
  String get shareRide => 'Share Ride';

  @override
  String get shareRideSubtitle =>
      'Share your live trip tracking link with family or friends';

  @override
  String get shareRideLinkLabel => 'Live tracking link';

  @override
  String get shareRideCopied => 'Trip link copied to clipboard';

  @override
  String get shareRideRevoke => 'Stop Sharing';

  @override
  String get shareRideRevoking => 'Revoking...';

  @override
  String get shareRideActive => 'Trip sharing is active';

  @override
  String get shareRideShareVia => 'Share via...';

  @override
  String get shareRideFailed => 'Failed to create share link';

  @override
  String get shareRideRevokeFailed => 'Failed to revoke share link';

  @override
  String get rideExpiredTitle => 'Ride Request Expired';

  @override
  String get rideExpiredSubtitle =>
      'No drivers were available in your area. Please try again.';

  @override
  String get drawerTripHistory => 'Trip History';

  @override
  String get tripHistoryTitle => 'Trip History';

  @override
  String get noTripHistory => 'No trip history found';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get commonAll => 'All';

  @override
  String get ratingPleaseSelectScore => 'Please select a star rating';

  @override
  String get ratingPleaseSelectTag => 'Please select at least one tag';

  @override
  String get ratingDontRate => 'Don\'t Rate';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle =>
      'We\'ll notify you when you receive new updates';

  @override
  String unreadNotificationsBadge(int count) {
    return '$count unread';
  }

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String notificationTripId(int id) {
    return 'Trip #$id';
  }

  @override
  String notificationRideRequestId(int id) {
    return 'Request #$id';
  }

  @override
  String get poolTransport => 'Pool Transport';

  @override
  String get poolFindLobby => 'Find Pool Lobby';

  @override
  String get poolCreateLobby => 'Create Pool Lobby';

  @override
  String get poolPublishLobby => 'Publish Pool Lobby';

  @override
  String get poolMatchingNearby => 'Matching Pools Nearby';

  @override
  String get poolSearchingLobbies => 'Searching for matching pool lobbies...';

  @override
  String get poolNoLobbiesFound => 'No Pool Lobbies Found';

  @override
  String get poolNoLobbiesFoundSubtitle =>
      'Be the first to create a pool lobby and other passengers traveling your direction will join you!';

  @override
  String get poolMeetingPoint => 'Shared Meeting Point';

  @override
  String get poolMeetingPointDesc => 'Walk here to meet the driver & riders';

  @override
  String get poolPassengersRoster => 'Passengers Roster';

  @override
  String get poolTargetDepartureTime => 'Target Departure Time';

  @override
  String get poolTotalCapacity => 'Total Passenger Capacity';

  @override
  String get poolCapacityDesc => 'Room will be sent to drivers once full.';

  @override
  String get poolSeatsYouNeed => 'Seats You Need';

  @override
  String get poolSeatsYouNeedDesc => 'Number of seats for you & companions';

  @override
  String get poolJoinSuccess => 'Joined pool room successfully!';

  @override
  String get poolCreateSuccess => 'Pool room created! Waiting in lobby.';

  @override
  String get poolCancelRoom => 'Cancel Pool Room';

  @override
  String get poolLeaveRoom => 'Leave Pool Room';

  @override
  String get poolCancelConfirmTitle => 'Cancel Pool Room?';

  @override
  String get poolCancelConfirmBody =>
      'Cancelling this room will disband the lobby and notify all joined passengers.';

  @override
  String get poolLeaveConfirmTitle => 'Leave Pool Room?';

  @override
  String get poolLeaveConfirmBody =>
      'Are you sure you want to leave this pool room? Your seat will become available for others.';

  @override
  String get poolDriverFound => 'Driver Found! Starting your ride.';

  @override
  String get poolExpiredTitle => 'Pool Room Expired';

  @override
  String get poolExpiredBody =>
      'No driver was matched before the departure time. The room has expired.';

  @override
  String get poolCancelledTitle => 'Pool Room Cancelled';

  @override
  String get poolCancelledBody => 'The host has cancelled this pool room.';

  @override
  String get poolRemovedTitle => 'Removed from Room';

  @override
  String get poolRemovedBody => 'You were removed from this pool room.';

  @override
  String get poolStatusLooking => 'Looking for Passengers';

  @override
  String get poolStatusReady => 'Finding Driver...';

  @override
  String get poolStatusMatched => 'Driver Assigned!';

  @override
  String get drawerModeration => 'Moderation & Restrictions';

  @override
  String get moderationTitle => 'Account Status & Moderation';

  @override
  String get moderationOverviewTab => 'Overview';

  @override
  String get moderationPenaltiesTab => 'Penalties';

  @override
  String get moderationViolationsTab => 'Violations';

  @override
  String get moderationAppealsTab => 'Appeals';

  @override
  String get moderationAccountStatus => 'Account Status';

  @override
  String get moderationStatusActive => 'Good Standing';

  @override
  String get moderationStatusWarning => 'Warning Issued';

  @override
  String get moderationStatusRestricted => 'Restricted';

  @override
  String get moderationStatusSuspended => 'Suspended';

  @override
  String get moderationStatusBanned => 'Banned';

  @override
  String get moderationActiveRestrictions => 'Active Restrictions';

  @override
  String get moderationActivePenalties => 'Active Penalties';

  @override
  String get moderationRecentViolations => 'Recent Violations';

  @override
  String get moderationActiveAppeals => 'Active Appeals';

  @override
  String get moderationWarningsCount => 'Warnings';

  @override
  String get moderationViolationsCount => 'Total Violations';

  @override
  String get moderationPenaltiesCount => 'Active Penalties';

  @override
  String get moderationRestrictionsCount => 'Restrictions';

  @override
  String get moderationSubmitAppeal => 'Submit Appeal';

  @override
  String get moderationAppealReason => 'Appeal Reason';

  @override
  String get moderationAppealReasonHint =>
      'Explain in detail why this penalty should be reviewed...';

  @override
  String get moderationAppealEvidence => 'Evidence URL (Optional)';

  @override
  String get moderationAppealEvidenceHint => 'https://example.com/proof.jpg';

  @override
  String get moderationAppealSubmitBtn => 'Submit Appeal';

  @override
  String get moderationAppealSubmitting => 'Submitting Appeal...';

  @override
  String get moderationAppealSuccess => 'Appeal submitted successfully';

  @override
  String get moderationAppealAlreadyExists =>
      'An appeal is already pending review for this penalty';

  @override
  String get moderationPenaltyNotAppealable =>
      'Only active penalties can be appealed';

  @override
  String get moderationAppealDetailsTitle => 'Appeal Details';

  @override
  String get moderationAdminDecision => 'Admin Decision';

  @override
  String get moderationAdminNotes => 'Admin Notes';

  @override
  String moderationExpiresAt(String date) {
    return 'Expires: $date';
  }

  @override
  String moderationStartsAt(String date) {
    return 'Starts: $date';
  }

  @override
  String moderationIssuedAt(String date) {
    return 'Issued: $date';
  }

  @override
  String moderationSubmittedAt(String date) {
    return 'Submitted: $date';
  }

  @override
  String moderationReviewedAt(String date) {
    return 'Reviewed: $date';
  }

  @override
  String get moderationNoPenalties => 'No penalties recorded';

  @override
  String get moderationNoViolations => 'No violations recorded';

  @override
  String get moderationNoAppeals => 'No appeals submitted';

  @override
  String get moderationNoRestrictions =>
      'No active restrictions on your account';

  @override
  String get moderationPermanentBanNotice => 'Permanent Ban (No Expiry)';

  @override
  String get moderationPenaltyTypeWarning => 'Warning';

  @override
  String get moderationPenaltyTypeSuspension => 'Temporary Suspension';

  @override
  String get moderationPenaltyTypeBan => 'Permanent Ban';

  @override
  String get moderationPenaltyTypeFeatureRestriction => 'Feature Restriction';

  @override
  String get moderationPenaltyTypeAccountRestriction => 'Account Restriction';

  @override
  String get moderationPenaltyStatusActive => 'Active';

  @override
  String get moderationPenaltyStatusExpired => 'Expired';

  @override
  String get moderationPenaltyStatusRevoked => 'Revoked';

  @override
  String get moderationPenaltyStatusCancelled => 'Cancelled';

  @override
  String get moderationRestrictionRequestRide => 'Ride Requests';

  @override
  String get moderationRestrictionJoinSharedRide => 'Join Shared Rides';

  @override
  String get moderationRestrictionJoinPassengerPool => 'Join Passenger Pools';

  @override
  String get moderationRestrictionWalletTransfer => 'Wallet Transfer';

  @override
  String get moderationRestrictionPayment => 'Payment Processing';

  @override
  String get moderationRestrictionFullAccount => 'Full Account Access';

  @override
  String get moderationViolationRiderTripCancellation => 'Ride Cancellation';

  @override
  String get moderationViolationNoShow => 'No Show at Pickup';

  @override
  String get moderationViolationLateCancellation => 'Late Cancellation';

  @override
  String get moderationViolationSharedRideMisuse => 'Shared Ride Misuse';

  @override
  String get moderationViolationPassengerPoolMisuse => 'Passenger Pool Misuse';

  @override
  String get moderationViolationPaymentAbuse => 'Payment Abuse';

  @override
  String get moderationViolationWalletAbuse => 'Wallet Abuse';

  @override
  String get moderationViolationAbusiveBehavior => 'Abusive Behavior';

  @override
  String get moderationViolationFraud => 'Fraud Activity';

  @override
  String get moderationViolationManualAdmin => 'Administrative Violation';

  @override
  String get moderationSeverityLow => 'Low';

  @override
  String get moderationSeverityMedium => 'Medium';

  @override
  String get moderationSeverityHigh => 'High';

  @override
  String get moderationSeverityCritical => 'Critical';

  @override
  String get moderationAppealStatusPending => 'Pending Review';

  @override
  String get moderationAppealStatusUnderReview => 'Under Review';

  @override
  String get moderationAppealStatusApproved => 'Approved';

  @override
  String get moderationAppealStatusRejected => 'Rejected';

  @override
  String get moderationAppealStatusCancelled => 'Cancelled';

  @override
  String get moderationReasonRequired => 'Please enter the appeal reason';

  @override
  String get moderationReasonTooLong => 'Reason cannot exceed 2000 characters';

  @override
  String get moderationInvalidEvidenceUrl => 'Please enter a valid URL';

  @override
  String moderationPenaltyRef(int id) {
    return 'Penalty #$id';
  }

  @override
  String moderationAppealRef(int id) {
    return 'Appeal #$id';
  }

  @override
  String get moderationRealtimePenaltyTitle => 'New Penalty Notice';

  @override
  String get moderationRealtimeLiftedTitle => 'Restriction Lifted';

  @override
  String get drawerActiveTrips => 'Active Trips';

  @override
  String get activeTripsTitle => 'Active Trips';

  @override
  String get activeTripsSubtitle => 'Ongoing & in-progress rides';

  @override
  String get activeTripsEmptyTitle => 'No Active Trips';

  @override
  String get activeTripsEmptySubtitle =>
      'You do not have any active or ongoing trips at the moment.';

  @override
  String get activeTripsLiveTracking => 'Live Tracking';

  @override
  String get activeTripsRegularTrip => 'Regular Ride';

  @override
  String get activeTripsSharedRide => 'Shared Ride';

  @override
  String get activeTripsCompanionBooking => 'Companion Booking';

  @override
  String get activeTripsSelf => 'Personal Ride';

  @override
  String activeTripsTripId(int id) {
    return 'Trip #$id';
  }

  @override
  String activeTripsRideRequestId(int id) {
    return 'Request #$id';
  }

  @override
  String activeTripsSharedRideId(int id) {
    return 'Room #$id';
  }

  @override
  String activeTripsPassengerId(int id) {
    return 'Passenger #$id';
  }

  @override
  String activeTripsActiveSeats(int count) {
    return '$count Active Seats';
  }

  @override
  String get activeTripsAccountHolderOnBoard => 'Account Holder On Board';

  @override
  String get activeTripsAccountHolderNotOnBoard => 'Companion On Board';

  @override
  String get activeTripsStatusStarted => 'Started';

  @override
  String get activeTripsStatusInProgress => 'In Progress';

  @override
  String get activeTripsStatusDriverArrived => 'Driver Arrived';

  @override
  String get activeTripsStatusOpen => 'Open Room';

  @override
  String get activeTripsStatusReady => 'Ready';

  @override
  String get activeTripsStatusAccepted => 'Accepted';

  @override
  String get activeTripsStatusPending => 'Finding Driver';

  @override
  String get commonNoResultsFound => 'No results found';

  @override
  String get unitKm => 'km';

  @override
  String get unitMin => 'min';

  @override
  String get unitStops => 'stops';

  @override
  String get rideChooseYourRide => 'Choose your ride';

  @override
  String get rideCarType => 'Car type';

  @override
  String get rideNoCarTypesAvailable =>
      'No car types are available for this trip right now.';

  @override
  String get sharedTripTryPoolInstead => 'Try Passenger Pool Instead';

  @override
  String get sharedTripRemovedTitle => 'Removed from Ride';

  @override
  String get sharedTripRemovedBody =>
      'You were removed from this shared ride by the driver.';

  @override
  String sharedTripRemovedBodyReason(String reason) {
    return 'You were removed from this shared ride by the driver.\n\nReason: $reason';
  }

  @override
  String get sharedTripCanceledNotice => 'The ride has been canceled.';

  @override
  String sharedTripCanceledReason(String reason) {
    return 'Trip Canceled: $reason';
  }

  @override
  String get sharedTripStartedNotice =>
      'Trip has started! Tracking live route.';

  @override
  String get sharedTripCompletedNotice =>
      'Trip completed! Thank you for riding.';

  @override
  String get poolCreateNewLobby => 'Create New Pool Lobby';

  @override
  String get poolCreateRoomTitle => 'Create Pool Room';

  @override
  String get poolYourJourney => 'Your Pool Journey';

  @override
  String poolLobbyTitle(int id) {
    return 'Pool Lobby #$id';
  }

  @override
  String poolDepartureTime(String time) {
    return 'Departure: $time';
  }

  @override
  String get poolWalkUnderOneMin => '< 1 min walk';

  @override
  String poolWalkMinutes(int minutes) {
    return '$minutes min walk';
  }

  @override
  String get poolOptimalMeetingPoint => 'Optimal central meeting point';

  @override
  String poolOccupiedSeats(int current, int total) {
    return '$current / $total Seats';
  }

  @override
  String poolPassengerNumber(int id) {
    return 'Passenger #$id';
  }

  @override
  String poolPassengerYou(String name) {
    return '$name (You)';
  }

  @override
  String get poolHost => 'Host';

  @override
  String poolSeatsRequested(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats requested',
      one: '1 seat requested',
    );
    return '$_temp0';
  }

  @override
  String get poolWaitingForPassenger => 'Waiting for a passenger...';

  @override
  String get poolStatusSwitchingTracking => 'Switching to active ride tracking';

  @override
  String poolStatusRoomFullDriversNotified(int current, int max) {
    return 'Room is full ($current/$max) • Drivers notified';
  }

  @override
  String poolStatusPassengersJoined(int current, int max) {
    return '$current/$max passengers joined';
  }

  @override
  String get poolDepartingSoon => 'Departing soon';

  @override
  String poolDepartsAt(String time) {
    return 'Departs at $time';
  }

  @override
  String poolSeatsOpen(int count, int max) {
    return '$count/$max seats open';
  }

  @override
  String poolHostedBy(String name) {
    return 'Hosted by $name';
  }

  @override
  String get poolJoinPool => 'Join Pool';

  @override
  String get drawerWallet => 'Wallet';

  @override
  String get walletBalance => 'Balance';

  @override
  String get walletStatusActive => 'Active';

  @override
  String get walletStatusInactive => 'Inactive';

  @override
  String get walletDetails => 'Wallet Details';

  @override
  String get walletId => 'Wallet ID';

  @override
  String get walletCreatedAt => 'Created Date';

  @override
  String get walletUpdatedAt => 'Last Updated';

  @override
  String get walletErrorLoading => 'Failed to load wallet';

  @override
  String get walletRetry => 'Retry';

  @override
  String get walletTransactions => 'Transactions';

  @override
  String get walletTransactionsHistory => 'Transaction History';

  @override
  String get walletDeposit => 'Deposit';

  @override
  String get walletWithdraw => 'Withdrawal';

  @override
  String get walletTransfer => 'Transfer';

  @override
  String get walletTripPayment => 'Trip Payment';

  @override
  String get walletNoTransactions => 'No transactions found';

  @override
  String get walletTapToViewTransactions => 'Tap to view transactions';

  @override
  String get walletBalanceAfter => 'Balance after';

  @override
  String get walletBalanceBefore => 'Balance before';
}
