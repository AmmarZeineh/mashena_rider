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
  String get homeWhereTo => 'Where to?';

  @override
  String get homeCurrentLocation => 'Current location';

  @override
  String get homeSearchDestination => 'Search destination';

  @override
  String get rideRequestRide => 'Request Ride';

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
  String validationMaxLength(int max) {
    return 'Maximum $max characters';
  }
}
