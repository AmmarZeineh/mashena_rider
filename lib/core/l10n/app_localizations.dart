import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mashena'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mashena'**
  String get appDescription;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @enableLocationBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable location to detect your pickup point automatically'**
  String get enableLocationBannerTitle;

  /// No description provided for @enableLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableLocationButton;

  /// No description provided for @locationServiceOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Location service is turned off'**
  String get locationServiceOffTitle;

  /// No description provided for @openSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get commonSelected;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Book a Ride Anytime'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Find a nearby driver and book your ride in seconds.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Track Your Driver Live'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'See your driver’s location and arrival time in real time.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Easy & Secure Payments'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Pay cash or online with complete safety and comfort.'**
  String get onboardingSubtitle3;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @enterYourNumberLogin.
  ///
  /// In en, this message translates to:
  /// **'Enter your number to login'**
  String get enterYourNumberLogin;

  /// No description provided for @enterYourNumberRegister.
  ///
  /// In en, this message translates to:
  /// **'Enter your number to sign up'**
  String get enterYourNumberRegister;

  /// No description provided for @enterYourEmailLogin.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to login'**
  String get enterYourEmailLogin;

  /// No description provided for @enterYourEmailRegister.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to sign up'**
  String get enterYourEmailRegister;

  /// No description provided for @enterDestination.
  ///
  /// In en, this message translates to:
  /// **'Enter Destination'**
  String get enterDestination;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegister;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogout;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get authSendCode;

  /// No description provided for @authDontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authDontHaveAnAccount;

  /// No description provided for @authPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get authPhone;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your phone'**
  String get authOtpSubtitle;

  /// No description provided for @authResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get authResendOtp;

  /// No description provided for @authOtpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification successful'**
  String get authOtpSuccess;

  /// No description provided for @otpResendSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully'**
  String get otpResendSuccess;

  /// No description provided for @homeWhereTo.
  ///
  /// In en, this message translates to:
  /// **'Where to?'**
  String get homeWhereTo;

  /// No description provided for @homeCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get homeCurrentLocation;

  /// No description provided for @homeSearchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search destination'**
  String get homeSearchDestination;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @makeSureInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get makeSureInternetConnection;

  /// No description provided for @rideRequestRide.
  ///
  /// In en, this message translates to:
  /// **'Request Ride'**
  String get rideRequestRide;

  /// No description provided for @rideRequestSharedTrip.
  ///
  /// In en, this message translates to:
  /// **'Shared Trip'**
  String get rideRequestSharedTrip;

  /// No description provided for @rideSharedTripSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share & save'**
  String get rideSharedTripSubtitle;

  /// No description provided for @sharedTripAvailableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available Shared Trips'**
  String get sharedTripAvailableRooms;

  /// No description provided for @sharedTripSearchRooms.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get sharedTripSearchRooms;

  /// No description provided for @sharedTripChangeLocations.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get sharedTripChangeLocations;

  /// No description provided for @sharedTripPickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get sharedTripPickup;

  /// No description provided for @sharedTripDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get sharedTripDestination;

  /// No description provided for @sharedTripSearchingRooms.
  ///
  /// In en, this message translates to:
  /// **'Searching for available shared trips...'**
  String get sharedTripSearchingRooms;

  /// No description provided for @sharedTripNoRoomsFound.
  ///
  /// In en, this message translates to:
  /// **'No shared trips found for this route.'**
  String get sharedTripNoRoomsFound;

  /// No description provided for @sharedTripFarePerSeat.
  ///
  /// In en, this message translates to:
  /// **'Fare per seat'**
  String get sharedTripFarePerSeat;

  /// No description provided for @sharedTripAvailableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available seats'**
  String get sharedTripAvailableSeats;

  /// No description provided for @sharedTripSeatsCount.
  ///
  /// In en, this message translates to:
  /// **'{available} of {total} seats'**
  String sharedTripSeatsCount(int available, int total);

  /// No description provided for @sharedTripDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get sharedTripDriver;

  /// No description provided for @sharedTripVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get sharedTripVehicle;

  /// No description provided for @sharedTripDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure Time'**
  String get sharedTripDepartureTime;

  /// No description provided for @sharedTripOriginDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km from pickup'**
  String sharedTripOriginDistance(String distance);

  /// No description provided for @sharedTripDestDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} km from destination'**
  String sharedTripDestDistance(String distance);

  /// No description provided for @currencySyp.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySyp;

  /// No description provided for @sharedTripStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get sharedTripStatusOpen;

  /// No description provided for @sharedTripRoomDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get sharedTripRoomDetailsTitle;

  /// No description provided for @sharedTripRouteOverview.
  ///
  /// In en, this message translates to:
  /// **'Route Overview'**
  String get sharedTripRouteOverview;

  /// No description provided for @sharedTripTotalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get sharedTripTotalDistance;

  /// No description provided for @sharedTripEstDuration.
  ///
  /// In en, this message translates to:
  /// **'Est. Duration'**
  String get sharedTripEstDuration;

  /// No description provided for @sharedTripDriverNotes.
  ///
  /// In en, this message translates to:
  /// **'Driver Notes & Instructions'**
  String get sharedTripDriverNotes;

  /// No description provided for @sharedTripOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Seat Occupancy'**
  String get sharedTripOccupancy;

  /// No description provided for @sharedTripOccupiedSeats.
  ///
  /// In en, this message translates to:
  /// **'{count} occupied'**
  String sharedTripOccupiedSeats(int count);

  /// No description provided for @sharedTripFreeSeats.
  ///
  /// In en, this message translates to:
  /// **'{count} available'**
  String sharedTripFreeSeats(int count);

  /// No description provided for @sharedTripFullFare.
  ///
  /// In en, this message translates to:
  /// **'Full Route Fare'**
  String get sharedTripFullFare;

  /// No description provided for @sharedTripMinFare.
  ///
  /// In en, this message translates to:
  /// **'Minimum Fare'**
  String get sharedTripMinFare;

  /// No description provided for @sharedTripBaseCost.
  ///
  /// In en, this message translates to:
  /// **'Total Base Fare'**
  String get sharedTripBaseCost;

  /// No description provided for @sharedTripJoinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join Shared Trip'**
  String get sharedTripJoinRoom;

  /// No description provided for @sharedTripRoomFull.
  ///
  /// In en, this message translates to:
  /// **'Trip is Full'**
  String get sharedTripRoomFull;

  /// No description provided for @sharedTripRoomClosed.
  ///
  /// In en, this message translates to:
  /// **'Trip is Closed'**
  String get sharedTripRoomClosed;

  /// No description provided for @sharedTripPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get sharedTripPassengers;

  /// No description provided for @sharedTripNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No special instructions provided.'**
  String get sharedTripNoNotes;

  /// No description provided for @sharedTripSelectSeatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Seats'**
  String get sharedTripSelectSeatsTitle;

  /// No description provided for @sharedTripSeatsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Seats Needed'**
  String get sharedTripSeatsNeeded;

  /// No description provided for @sharedTripJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined shared trip successfully!'**
  String get sharedTripJoinSuccess;

  /// No description provided for @sharedTripArrivedTitle.
  ///
  /// In en, this message translates to:
  /// **'You Have Arrived!'**
  String get sharedTripArrivedTitle;

  /// No description provided for @sharedTripArrivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hope you enjoyed your shared trip.'**
  String get sharedTripArrivedSubtitle;

  /// No description provided for @sharedTripBackToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get sharedTripBackToHome;

  /// No description provided for @sharedTripFinalFare.
  ///
  /// In en, this message translates to:
  /// **'Final Fare'**
  String get sharedTripFinalFare;

  /// No description provided for @sharedTripConfirmJoin.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Join'**
  String get sharedTripConfirmJoin;

  /// No description provided for @sharedTripLeaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Leave Shared Trip'**
  String get sharedTripLeaveRoom;

  /// No description provided for @sharedTripLeaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Shared Trip?'**
  String get sharedTripLeaveConfirmTitle;

  /// No description provided for @sharedTripLeaveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this shared trip? Your seat will become available for others.'**
  String get sharedTripLeaveConfirmBody;

  /// No description provided for @sharedTripLeaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have left the shared trip.'**
  String get sharedTripLeaveSuccess;

  /// No description provided for @sharedTripCompanionDropped.
  ///
  /// In en, this message translates to:
  /// **'A companion has been dropped off. Fare: {fare} {currency}'**
  String sharedTripCompanionDropped(String fare, String currency);

  /// No description provided for @rideFindingDriver.
  ///
  /// In en, this message translates to:
  /// **'Finding a driver...'**
  String get rideFindingDriver;

  /// No description provided for @rideDriverOnWay.
  ///
  /// In en, this message translates to:
  /// **'Driver is on the way'**
  String get rideDriverOnWay;

  /// No description provided for @rideDriverArrived.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived'**
  String get rideDriverArrived;

  /// No description provided for @rideTripStarted.
  ///
  /// In en, this message translates to:
  /// **'Trip started'**
  String get rideTripStarted;

  /// No description provided for @rideTripEnded.
  ///
  /// In en, this message translates to:
  /// **'Trip ended'**
  String get rideTripEnded;

  /// No description provided for @rideCancelRide.
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride'**
  String get rideCancelRide;

  /// No description provided for @rideEstimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get rideEstimatedTime;

  /// No description provided for @rideEstimatedPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated price'**
  String get rideEstimatedPrice;

  /// No description provided for @paymentPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentPaymentMethod;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentOnline.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get paymentOnline;

  /// No description provided for @paymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get paymentTotal;

  /// No description provided for @paymentPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get paymentPayNow;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get paymentFailed;

  /// No description provided for @ratingRateDriver.
  ///
  /// In en, this message translates to:
  /// **'Rate Driver'**
  String get ratingRateDriver;

  /// No description provided for @ratingLeaveComment.
  ///
  /// In en, this message translates to:
  /// **'Leave a comment (optional)'**
  String get ratingLeaveComment;

  /// No description provided for @ratingSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get ratingSubmitRating;

  /// No description provided for @profileProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileProfile;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @settingsSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSettings;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get settingsChangeLanguage;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get settingsAboutApp;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how Mashena Rider looks to you'**
  String get settingsThemeSubtitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Match your device system settings'**
  String get settingsThemeSystemDesc;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic bright look with optimal clarity'**
  String get settingsThemeLightDesc;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Easy on the eyes in low-light conditions'**
  String get settingsThemeDarkDesc;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred application language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية (Arabic)'**
  String get settingsLanguageArabic;

  /// No description provided for @settingsAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App Information'**
  String get settingsAppInfo;

  /// No description provided for @settingsAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get settingsAppVersion;

  /// No description provided for @settingsAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Mashena Rider - Safe, reliable and comfortable rides'**
  String get settingsAppDescription;

  /// No description provided for @errorsNetwork.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get errorsNetwork;

  /// No description provided for @errorsUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get errorsUnauthorized;

  /// No description provided for @errorsLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Please allow location access'**
  String get errorsLocationPermission;

  /// No description provided for @apiConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get apiConnectionTimeout;

  /// No description provided for @apiSendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout'**
  String get apiSendTimeout;

  /// No description provided for @apiReceiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout'**
  String get apiReceiveTimeout;

  /// No description provided for @apiRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get apiRequestCancelled;

  /// No description provided for @apiConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get apiConnectionError;

  /// No description provided for @apiCertificateError.
  ///
  /// In en, this message translates to:
  /// **'Certificate error'**
  String get apiCertificateError;

  /// No description provided for @apiBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get apiBadRequest;

  /// No description provided for @apiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get apiUnauthorized;

  /// No description provided for @apiForbidden.
  ///
  /// In en, this message translates to:
  /// **'Forbidden'**
  String get apiForbidden;

  /// No description provided for @apiNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get apiNotFound;

  /// No description provided for @apiValidationError.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get apiValidationError;

  /// No description provided for @apiServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get apiServerError;

  /// No description provided for @apiBadGateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get apiBadGateway;

  /// No description provided for @apiServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get apiServiceUnavailable;

  /// No description provided for @apiRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed ({code})'**
  String apiRequestFailed(Object code);

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get otpTitle;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A code has been sent to {phone}'**
  String otpSubtitle(Object phone);

  /// No description provided for @otpDidNotReceive.
  ///
  /// In en, this message translates to:
  /// **'Don\'t receive a code?'**
  String get otpDidNotReceive;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get otpResend;

  /// No description provided for @otpVerifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get otpVerifyNow;

  /// No description provided for @apiUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get apiUnknownError;

  /// No description provided for @cacheError.
  ///
  /// In en, this message translates to:
  /// **'Cache error'**
  String get cacheError;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get validationInvalidPhone;

  /// No description provided for @validationWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Weak password (uppercase, lowercase, number, symbol)'**
  String get validationWeakPassword;

  /// No description provided for @validationOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get validationOtpInvalid;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum {min} characters'**
  String validationMinLength(int min);

  /// No description provided for @validationPasswordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordsNotMatch;

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} characters'**
  String validationMaxLength(int max);

  /// No description provided for @locationPermissionRationaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get locationPermissionRationaleTitle;

  /// No description provided for @locationPermissionRationaleBody.
  ///
  /// In en, this message translates to:
  /// **'Mashena needs your location to show your position on the map, auto-detect your pickup point, and connect you with nearby drivers.'**
  String get locationPermissionRationaleBody;

  /// No description provided for @locationPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get locationPermissionAllow;

  /// No description provided for @locationPermissionDeniedForeverTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionDeniedForeverTitle;

  /// No description provided for @locationPermissionDeniedForeverBody.
  ///
  /// In en, this message translates to:
  /// **'You have permanently denied location access. Please open Settings and enable it manually.'**
  String get locationPermissionDeniedForeverBody;

  /// No description provided for @mapDragToMovePin.
  ///
  /// In en, this message translates to:
  /// **'Drag map to move pin'**
  String get mapDragToMovePin;

  /// No description provided for @mapConfirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get mapConfirmLocation;

  /// No description provided for @homeNowYouCanAddMultipleStops.
  ///
  /// In en, this message translates to:
  /// **'Now you can add multiple stops'**
  String get homeNowYouCanAddMultipleStops;

  /// No description provided for @rideAvailableRides.
  ///
  /// In en, this message translates to:
  /// **'Available Rides'**
  String get rideAvailableRides;

  /// No description provided for @rideBookRide.
  ///
  /// In en, this message translates to:
  /// **'Book Ride'**
  String get rideBookRide;

  /// No description provided for @rideNoTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ride types available for this trip right now.'**
  String get rideNoTypesAvailable;

  /// No description provided for @rideDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String rideDistanceKm(String distance);

  /// No description provided for @rideDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{duration} min'**
  String rideDurationMin(String duration);

  /// No description provided for @rideStopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stop(s)'**
  String rideStopsCount(int count);

  /// No description provided for @ridePersonCapacity.
  ///
  /// In en, this message translates to:
  /// **'4+1 Person'**
  String get ridePersonCapacity;

  /// No description provided for @homeMapRouteUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Map route currently unavailable. Markers show your trip stops.'**
  String get homeMapRouteUnavailable;

  /// No description provided for @rideConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Ride Confirmed'**
  String get rideConfirmed;

  /// No description provided for @driverRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get driverRating;

  /// No description provided for @driverTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get driverTrips;

  /// No description provided for @driverYears.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get driverYears;

  /// No description provided for @driverVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get driverVehicleDetails;

  /// No description provided for @driverLicensePlate.
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get driverLicensePlate;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @rideEstFare.
  ///
  /// In en, this message translates to:
  /// **'Est. Fare'**
  String get rideEstFare;

  /// No description provided for @rideDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get rideDistance;

  /// No description provided for @rideDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get rideDuration;

  /// No description provided for @commonPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get commonPleaseWait;

  /// No description provided for @rideLookingForDrivers.
  ///
  /// In en, this message translates to:
  /// **'Looking for nearby drivers...'**
  String get rideLookingForDrivers;

  /// No description provided for @rideTakesFewMoments.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a few moments'**
  String get rideTakesFewMoments;

  /// No description provided for @simulateEndTrip.
  ///
  /// In en, this message translates to:
  /// **'Simulate End Trip'**
  String get simulateEndTrip;

  /// No description provided for @tripCancelledByDriver.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled by driver'**
  String get tripCancelledByDriver;

  /// No description provided for @tripCancelledByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled by admin'**
  String get tripCancelledByAdmin;

  /// No description provided for @tripCancelled.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled'**
  String get tripCancelled;

  /// No description provided for @tripCancelledSubtitleDriver.
  ///
  /// In en, this message translates to:
  /// **'Your driver cancelled the ride request. You can request a new ride anytime.'**
  String get tripCancelledSubtitleDriver;

  /// No description provided for @tripCancelledSubtitleAdmin.
  ///
  /// In en, this message translates to:
  /// **'The ride was cancelled by the system administrator.'**
  String get tripCancelledSubtitleAdmin;

  /// No description provided for @tripCancelledSubtitleGeneral.
  ///
  /// In en, this message translates to:
  /// **'Your trip request has been cancelled.'**
  String get tripCancelledSubtitleGeneral;

  /// No description provided for @noCancellationFeeNotice.
  ///
  /// In en, this message translates to:
  /// **'No cancellation fee was charged for this ride.'**
  String get noCancellationFeeNotice;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout from this device or all devices?'**
  String get logoutConfirmationMessage;

  /// No description provided for @logoutThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get logoutThisDevice;

  /// No description provided for @logoutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'All Devices'**
  String get logoutAllDevices;

  /// No description provided for @drawerMyAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get drawerMyAccount;

  /// No description provided for @drawerFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get drawerFavourites;

  /// No description provided for @drawerFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get drawerFaq;

  /// No description provided for @drawerSos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get drawerSos;

  /// No description provided for @drawerMakeComplaints.
  ///
  /// In en, this message translates to:
  /// **'Make Complaints'**
  String get drawerMakeComplaints;

  /// No description provided for @drawerNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get drawerNotification;

  /// No description provided for @drawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get drawerAbout;

  /// No description provided for @drawerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get drawerPrivacyPolicy;

  /// No description provided for @drawerTermsCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Condition'**
  String get drawerTermsCondition;

  /// No description provided for @drawerGuestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get drawerGuestUser;

  /// No description provided for @rideLoadingDriverDetails.
  ///
  /// In en, this message translates to:
  /// **'Loading driver details...'**
  String get rideLoadingDriverDetails;

  /// No description provided for @rideVehicleModelAndColor.
  ///
  /// In en, this message translates to:
  /// **'{vehicleModel} • {vehicleColor}'**
  String rideVehicleModelAndColor(String vehicleModel, String vehicleColor);

  /// No description provided for @rideDriverArrivedAtPickup.
  ///
  /// In en, this message translates to:
  /// **'Your driver has arrived at the pickup location!'**
  String get rideDriverArrivedAtPickup;

  /// No description provided for @rideWaitingChargesWarning.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Waiting charges may apply after the free wait timer expires.'**
  String get rideWaitingChargesWarning;

  /// No description provided for @rideInProgressHeadingToDestination.
  ///
  /// In en, this message translates to:
  /// **'In Progress • Heading to Destination'**
  String get rideInProgressHeadingToDestination;

  /// No description provided for @rideWaitingChargesApplying.
  ///
  /// In en, this message translates to:
  /// **'⏱️ 00:00 • Waiting charges are now applying'**
  String get rideWaitingChargesApplying;

  /// No description provided for @rideFreeWaitingTime.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Free waiting time: {minutes}:{seconds}'**
  String rideFreeWaitingTime(String minutes, String seconds);

  /// No description provided for @rideVehicleDefault.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get rideVehicleDefault;

  /// No description provided for @rideVehicleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get rideVehicleStandard;

  /// No description provided for @rideVehicleColorAndType.
  ///
  /// In en, this message translates to:
  /// **'{color} • {type}'**
  String rideVehicleColorAndType(String color, String type);

  /// No description provided for @drawerCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get drawerCoupons;

  /// No description provided for @applyCouponTitle.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCouponTitle;

  /// No description provided for @enterCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponHint;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @activeCouponsSection.
  ///
  /// In en, this message translates to:
  /// **'Active Coupons'**
  String get activeCouponsSection;

  /// No description provided for @couponHistorySection.
  ///
  /// In en, this message translates to:
  /// **'Coupon History'**
  String get couponHistorySection;

  /// No description provided for @noActiveCoupons.
  ///
  /// In en, this message translates to:
  /// **'No active coupons available'**
  String get noActiveCoupons;

  /// No description provided for @noCouponHistory.
  ///
  /// In en, this message translates to:
  /// **'No coupon history found'**
  String get noCouponHistory;

  /// No description provided for @remainingUsages.
  ///
  /// In en, this message translates to:
  /// **'{count} usages remaining'**
  String remainingUsages(num count);

  /// No description provided for @couponStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get couponStatusActive;

  /// No description provided for @couponStatusUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get couponStatusUsed;

  /// No description provided for @couponStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get couponStatusExpired;

  /// No description provided for @expiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String expiresOn(String date);

  /// No description provided for @couponAppliedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully'**
  String get couponAppliedSuccess;

  /// No description provided for @enterValidCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a coupon code'**
  String get enterValidCouponCode;

  /// No description provided for @couponOriginalFare.
  ///
  /// In en, this message translates to:
  /// **'Original Fare'**
  String get couponOriginalFare;

  /// No description provided for @couponSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get couponSaved;

  /// No description provided for @couponFinalFare.
  ///
  /// In en, this message translates to:
  /// **'Final Fare'**
  String get couponFinalFare;

  /// No description provided for @appCurrency.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get appCurrency;

  /// No description provided for @shareRide.
  ///
  /// In en, this message translates to:
  /// **'Share Ride'**
  String get shareRide;

  /// No description provided for @shareRideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your live trip tracking link with family or friends'**
  String get shareRideSubtitle;

  /// No description provided for @shareRideLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Live tracking link'**
  String get shareRideLinkLabel;

  /// No description provided for @shareRideCopied.
  ///
  /// In en, this message translates to:
  /// **'Trip link copied to clipboard'**
  String get shareRideCopied;

  /// No description provided for @shareRideRevoke.
  ///
  /// In en, this message translates to:
  /// **'Stop Sharing'**
  String get shareRideRevoke;

  /// No description provided for @shareRideRevoking.
  ///
  /// In en, this message translates to:
  /// **'Revoking...'**
  String get shareRideRevoking;

  /// No description provided for @shareRideActive.
  ///
  /// In en, this message translates to:
  /// **'Trip sharing is active'**
  String get shareRideActive;

  /// No description provided for @shareRideShareVia.
  ///
  /// In en, this message translates to:
  /// **'Share via...'**
  String get shareRideShareVia;

  /// No description provided for @shareRideFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create share link'**
  String get shareRideFailed;

  /// No description provided for @shareRideRevokeFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to revoke share link'**
  String get shareRideRevokeFailed;

  /// No description provided for @rideExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Ride Request Expired'**
  String get rideExpiredTitle;

  /// No description provided for @rideExpiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No drivers were available in your area. Please try again.'**
  String get rideExpiredSubtitle;

  /// No description provided for @drawerTripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get drawerTripHistory;

  /// No description provided for @tripHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip History'**
  String get tripHistoryTitle;

  /// No description provided for @noTripHistory.
  ///
  /// In en, this message translates to:
  /// **'No trip history found'**
  String get noTripHistory;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @ratingPleaseSelectScore.
  ///
  /// In en, this message translates to:
  /// **'Please select a star rating'**
  String get ratingPleaseSelectScore;

  /// No description provided for @ratingPleaseSelectTag.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one tag'**
  String get ratingPleaseSelectTag;

  /// No description provided for @ratingDontRate.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Rate'**
  String get ratingDontRate;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when you receive new updates'**
  String get notificationsEmptySubtitle;

  /// No description provided for @unreadNotificationsBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadNotificationsBadge(int count);

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @notificationTripId.
  ///
  /// In en, this message translates to:
  /// **'Trip #{id}'**
  String notificationTripId(int id);

  /// No description provided for @notificationRideRequestId.
  ///
  /// In en, this message translates to:
  /// **'Request #{id}'**
  String notificationRideRequestId(int id);

  /// No description provided for @poolTransport.
  ///
  /// In en, this message translates to:
  /// **'Pool Transport'**
  String get poolTransport;

  /// No description provided for @poolFindLobby.
  ///
  /// In en, this message translates to:
  /// **'Find Pool Lobby'**
  String get poolFindLobby;

  /// No description provided for @poolCreateLobby.
  ///
  /// In en, this message translates to:
  /// **'Create Pool Lobby'**
  String get poolCreateLobby;

  /// No description provided for @poolPublishLobby.
  ///
  /// In en, this message translates to:
  /// **'Publish Pool Lobby'**
  String get poolPublishLobby;

  /// No description provided for @poolMatchingNearby.
  ///
  /// In en, this message translates to:
  /// **'Matching Pools Nearby'**
  String get poolMatchingNearby;

  /// No description provided for @poolSearchingLobbies.
  ///
  /// In en, this message translates to:
  /// **'Searching for matching pool lobbies...'**
  String get poolSearchingLobbies;

  /// No description provided for @poolNoLobbiesFound.
  ///
  /// In en, this message translates to:
  /// **'No Pool Lobbies Found'**
  String get poolNoLobbiesFound;

  /// No description provided for @poolNoLobbiesFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to create a pool lobby and other passengers traveling your direction will join you!'**
  String get poolNoLobbiesFoundSubtitle;

  /// No description provided for @poolMeetingPoint.
  ///
  /// In en, this message translates to:
  /// **'Shared Meeting Point'**
  String get poolMeetingPoint;

  /// No description provided for @poolMeetingPointDesc.
  ///
  /// In en, this message translates to:
  /// **'Walk here to meet the driver & riders'**
  String get poolMeetingPointDesc;

  /// No description provided for @poolPassengersRoster.
  ///
  /// In en, this message translates to:
  /// **'Passengers Roster'**
  String get poolPassengersRoster;

  /// No description provided for @poolTargetDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Target Departure Time'**
  String get poolTargetDepartureTime;

  /// No description provided for @poolTotalCapacity.
  ///
  /// In en, this message translates to:
  /// **'Total Passenger Capacity'**
  String get poolTotalCapacity;

  /// No description provided for @poolCapacityDesc.
  ///
  /// In en, this message translates to:
  /// **'Room will be sent to drivers once full.'**
  String get poolCapacityDesc;

  /// No description provided for @poolSeatsYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Seats You Need'**
  String get poolSeatsYouNeed;

  /// No description provided for @poolSeatsYouNeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Number of seats for you & companions'**
  String get poolSeatsYouNeedDesc;

  /// No description provided for @poolJoinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Joined pool room successfully!'**
  String get poolJoinSuccess;

  /// No description provided for @poolCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pool room created! Waiting in lobby.'**
  String get poolCreateSuccess;

  /// No description provided for @poolCancelRoom.
  ///
  /// In en, this message translates to:
  /// **'Cancel Pool Room'**
  String get poolCancelRoom;

  /// No description provided for @poolLeaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Leave Pool Room'**
  String get poolLeaveRoom;

  /// No description provided for @poolCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Pool Room?'**
  String get poolCancelConfirmTitle;

  /// No description provided for @poolCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelling this room will disband the lobby and notify all joined passengers.'**
  String get poolCancelConfirmBody;

  /// No description provided for @poolLeaveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Pool Room?'**
  String get poolLeaveConfirmTitle;

  /// No description provided for @poolLeaveConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this pool room? Your seat will become available for others.'**
  String get poolLeaveConfirmBody;

  /// No description provided for @poolDriverFound.
  ///
  /// In en, this message translates to:
  /// **'Driver Found! Starting your ride.'**
  String get poolDriverFound;

  /// No description provided for @poolExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Pool Room Expired'**
  String get poolExpiredTitle;

  /// No description provided for @poolExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'No driver was matched before the departure time. The room has expired.'**
  String get poolExpiredBody;

  /// No description provided for @poolCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Pool Room Cancelled'**
  String get poolCancelledTitle;

  /// No description provided for @poolCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'The host has cancelled this pool room.'**
  String get poolCancelledBody;

  /// No description provided for @poolRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed from Room'**
  String get poolRemovedTitle;

  /// No description provided for @poolRemovedBody.
  ///
  /// In en, this message translates to:
  /// **'You were removed from this pool room.'**
  String get poolRemovedBody;

  /// No description provided for @poolStatusLooking.
  ///
  /// In en, this message translates to:
  /// **'Looking for Passengers'**
  String get poolStatusLooking;

  /// No description provided for @poolStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Finding Driver...'**
  String get poolStatusReady;

  /// No description provided for @poolStatusMatched.
  ///
  /// In en, this message translates to:
  /// **'Driver Assigned!'**
  String get poolStatusMatched;

  /// No description provided for @drawerModeration.
  ///
  /// In en, this message translates to:
  /// **'Moderation & Restrictions'**
  String get drawerModeration;

  /// No description provided for @moderationTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Status & Moderation'**
  String get moderationTitle;

  /// No description provided for @moderationOverviewTab.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get moderationOverviewTab;

  /// No description provided for @moderationPenaltiesTab.
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get moderationPenaltiesTab;

  /// No description provided for @moderationViolationsTab.
  ///
  /// In en, this message translates to:
  /// **'Violations'**
  String get moderationViolationsTab;

  /// No description provided for @moderationAppealsTab.
  ///
  /// In en, this message translates to:
  /// **'Appeals'**
  String get moderationAppealsTab;

  /// No description provided for @moderationAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get moderationAccountStatus;

  /// No description provided for @moderationStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Good Standing'**
  String get moderationStatusActive;

  /// No description provided for @moderationStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning Issued'**
  String get moderationStatusWarning;

  /// No description provided for @moderationStatusRestricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get moderationStatusRestricted;

  /// No description provided for @moderationStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get moderationStatusSuspended;

  /// No description provided for @moderationStatusBanned.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get moderationStatusBanned;

  /// No description provided for @moderationActiveRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Active Restrictions'**
  String get moderationActiveRestrictions;

  /// No description provided for @moderationActivePenalties.
  ///
  /// In en, this message translates to:
  /// **'Active Penalties'**
  String get moderationActivePenalties;

  /// No description provided for @moderationRecentViolations.
  ///
  /// In en, this message translates to:
  /// **'Recent Violations'**
  String get moderationRecentViolations;

  /// No description provided for @moderationActiveAppeals.
  ///
  /// In en, this message translates to:
  /// **'Active Appeals'**
  String get moderationActiveAppeals;

  /// No description provided for @moderationWarningsCount.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get moderationWarningsCount;

  /// No description provided for @moderationViolationsCount.
  ///
  /// In en, this message translates to:
  /// **'Total Violations'**
  String get moderationViolationsCount;

  /// No description provided for @moderationPenaltiesCount.
  ///
  /// In en, this message translates to:
  /// **'Active Penalties'**
  String get moderationPenaltiesCount;

  /// No description provided for @moderationRestrictionsCount.
  ///
  /// In en, this message translates to:
  /// **'Restrictions'**
  String get moderationRestrictionsCount;

  /// No description provided for @moderationSubmitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Submit Appeal'**
  String get moderationSubmitAppeal;

  /// No description provided for @moderationAppealReason.
  ///
  /// In en, this message translates to:
  /// **'Appeal Reason'**
  String get moderationAppealReason;

  /// No description provided for @moderationAppealReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Explain in detail why this penalty should be reviewed...'**
  String get moderationAppealReasonHint;

  /// No description provided for @moderationAppealEvidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence URL (Optional)'**
  String get moderationAppealEvidence;

  /// No description provided for @moderationAppealEvidenceHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/proof.jpg'**
  String get moderationAppealEvidenceHint;

  /// No description provided for @moderationAppealSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Appeal'**
  String get moderationAppealSubmitBtn;

  /// No description provided for @moderationAppealSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting Appeal...'**
  String get moderationAppealSubmitting;

  /// No description provided for @moderationAppealSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appeal submitted successfully'**
  String get moderationAppealSuccess;

  /// No description provided for @moderationAppealAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'An appeal is already pending review for this penalty'**
  String get moderationAppealAlreadyExists;

  /// No description provided for @moderationPenaltyNotAppealable.
  ///
  /// In en, this message translates to:
  /// **'Only active penalties can be appealed'**
  String get moderationPenaltyNotAppealable;

  /// No description provided for @moderationAppealDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appeal Details'**
  String get moderationAppealDetailsTitle;

  /// No description provided for @moderationAdminDecision.
  ///
  /// In en, this message translates to:
  /// **'Admin Decision'**
  String get moderationAdminDecision;

  /// No description provided for @moderationAdminNotes.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get moderationAdminNotes;

  /// No description provided for @moderationExpiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String moderationExpiresAt(String date);

  /// No description provided for @moderationStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Starts: {date}'**
  String moderationStartsAt(String date);

  /// No description provided for @moderationIssuedAt.
  ///
  /// In en, this message translates to:
  /// **'Issued: {date}'**
  String moderationIssuedAt(String date);

  /// No description provided for @moderationSubmittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String moderationSubmittedAt(String date);

  /// No description provided for @moderationReviewedAt.
  ///
  /// In en, this message translates to:
  /// **'Reviewed: {date}'**
  String moderationReviewedAt(String date);

  /// No description provided for @moderationNoPenalties.
  ///
  /// In en, this message translates to:
  /// **'No penalties recorded'**
  String get moderationNoPenalties;

  /// No description provided for @moderationNoViolations.
  ///
  /// In en, this message translates to:
  /// **'No violations recorded'**
  String get moderationNoViolations;

  /// No description provided for @moderationNoAppeals.
  ///
  /// In en, this message translates to:
  /// **'No appeals submitted'**
  String get moderationNoAppeals;

  /// No description provided for @moderationNoRestrictions.
  ///
  /// In en, this message translates to:
  /// **'No active restrictions on your account'**
  String get moderationNoRestrictions;

  /// No description provided for @moderationPermanentBanNotice.
  ///
  /// In en, this message translates to:
  /// **'Permanent Ban (No Expiry)'**
  String get moderationPermanentBanNotice;

  /// No description provided for @moderationPenaltyTypeWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get moderationPenaltyTypeWarning;

  /// No description provided for @moderationPenaltyTypeSuspension.
  ///
  /// In en, this message translates to:
  /// **'Temporary Suspension'**
  String get moderationPenaltyTypeSuspension;

  /// No description provided for @moderationPenaltyTypeBan.
  ///
  /// In en, this message translates to:
  /// **'Permanent Ban'**
  String get moderationPenaltyTypeBan;

  /// No description provided for @moderationPenaltyTypeFeatureRestriction.
  ///
  /// In en, this message translates to:
  /// **'Feature Restriction'**
  String get moderationPenaltyTypeFeatureRestriction;

  /// No description provided for @moderationPenaltyTypeAccountRestriction.
  ///
  /// In en, this message translates to:
  /// **'Account Restriction'**
  String get moderationPenaltyTypeAccountRestriction;

  /// No description provided for @moderationPenaltyStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get moderationPenaltyStatusActive;

  /// No description provided for @moderationPenaltyStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get moderationPenaltyStatusExpired;

  /// No description provided for @moderationPenaltyStatusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get moderationPenaltyStatusRevoked;

  /// No description provided for @moderationPenaltyStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get moderationPenaltyStatusCancelled;

  /// No description provided for @moderationRestrictionRequestRide.
  ///
  /// In en, this message translates to:
  /// **'Ride Requests'**
  String get moderationRestrictionRequestRide;

  /// No description provided for @moderationRestrictionJoinSharedRide.
  ///
  /// In en, this message translates to:
  /// **'Join Shared Rides'**
  String get moderationRestrictionJoinSharedRide;

  /// No description provided for @moderationRestrictionJoinPassengerPool.
  ///
  /// In en, this message translates to:
  /// **'Join Passenger Pools'**
  String get moderationRestrictionJoinPassengerPool;

  /// No description provided for @moderationRestrictionWalletTransfer.
  ///
  /// In en, this message translates to:
  /// **'Wallet Transfer'**
  String get moderationRestrictionWalletTransfer;

  /// No description provided for @moderationRestrictionPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment Processing'**
  String get moderationRestrictionPayment;

  /// No description provided for @moderationRestrictionFullAccount.
  ///
  /// In en, this message translates to:
  /// **'Full Account Access'**
  String get moderationRestrictionFullAccount;

  /// No description provided for @moderationViolationRiderTripCancellation.
  ///
  /// In en, this message translates to:
  /// **'Ride Cancellation'**
  String get moderationViolationRiderTripCancellation;

  /// No description provided for @moderationViolationNoShow.
  ///
  /// In en, this message translates to:
  /// **'No Show at Pickup'**
  String get moderationViolationNoShow;

  /// No description provided for @moderationViolationLateCancellation.
  ///
  /// In en, this message translates to:
  /// **'Late Cancellation'**
  String get moderationViolationLateCancellation;

  /// No description provided for @moderationViolationSharedRideMisuse.
  ///
  /// In en, this message translates to:
  /// **'Shared Ride Misuse'**
  String get moderationViolationSharedRideMisuse;

  /// No description provided for @moderationViolationPassengerPoolMisuse.
  ///
  /// In en, this message translates to:
  /// **'Passenger Pool Misuse'**
  String get moderationViolationPassengerPoolMisuse;

  /// No description provided for @moderationViolationPaymentAbuse.
  ///
  /// In en, this message translates to:
  /// **'Payment Abuse'**
  String get moderationViolationPaymentAbuse;

  /// No description provided for @moderationViolationWalletAbuse.
  ///
  /// In en, this message translates to:
  /// **'Wallet Abuse'**
  String get moderationViolationWalletAbuse;

  /// No description provided for @moderationViolationAbusiveBehavior.
  ///
  /// In en, this message translates to:
  /// **'Abusive Behavior'**
  String get moderationViolationAbusiveBehavior;

  /// No description provided for @moderationViolationFraud.
  ///
  /// In en, this message translates to:
  /// **'Fraud Activity'**
  String get moderationViolationFraud;

  /// No description provided for @moderationViolationManualAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrative Violation'**
  String get moderationViolationManualAdmin;

  /// No description provided for @moderationSeverityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moderationSeverityLow;

  /// No description provided for @moderationSeverityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get moderationSeverityMedium;

  /// No description provided for @moderationSeverityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get moderationSeverityHigh;

  /// No description provided for @moderationSeverityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get moderationSeverityCritical;

  /// No description provided for @moderationAppealStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get moderationAppealStatusPending;

  /// No description provided for @moderationAppealStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get moderationAppealStatusUnderReview;

  /// No description provided for @moderationAppealStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get moderationAppealStatusApproved;

  /// No description provided for @moderationAppealStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get moderationAppealStatusRejected;

  /// No description provided for @moderationAppealStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get moderationAppealStatusCancelled;

  /// No description provided for @moderationReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the appeal reason'**
  String get moderationReasonRequired;

  /// No description provided for @moderationReasonTooLong.
  ///
  /// In en, this message translates to:
  /// **'Reason cannot exceed 2000 characters'**
  String get moderationReasonTooLong;

  /// No description provided for @moderationInvalidEvidenceUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get moderationInvalidEvidenceUrl;

  /// No description provided for @moderationPenaltyRef.
  ///
  /// In en, this message translates to:
  /// **'Penalty #{id}'**
  String moderationPenaltyRef(int id);

  /// No description provided for @moderationAppealRef.
  ///
  /// In en, this message translates to:
  /// **'Appeal #{id}'**
  String moderationAppealRef(int id);

  /// No description provided for @moderationRealtimePenaltyTitle.
  ///
  /// In en, this message translates to:
  /// **'New Penalty Notice'**
  String get moderationRealtimePenaltyTitle;

  /// No description provided for @moderationRealtimeLiftedTitle.
  ///
  /// In en, this message translates to:
  /// **'Restriction Lifted'**
  String get moderationRealtimeLiftedTitle;

  /// No description provided for @drawerActiveTrips.
  ///
  /// In en, this message translates to:
  /// **'Active Trips'**
  String get drawerActiveTrips;

  /// No description provided for @activeTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Trips'**
  String get activeTripsTitle;

  /// No description provided for @activeTripsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ongoing & in-progress rides'**
  String get activeTripsSubtitle;

  /// No description provided for @activeTripsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Active Trips'**
  String get activeTripsEmptyTitle;

  /// No description provided for @activeTripsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You do not have any active or ongoing trips at the moment.'**
  String get activeTripsEmptySubtitle;

  /// No description provided for @activeTripsLiveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get activeTripsLiveTracking;

  /// No description provided for @activeTripsRegularTrip.
  ///
  /// In en, this message translates to:
  /// **'Regular Ride'**
  String get activeTripsRegularTrip;

  /// No description provided for @activeTripsSharedRide.
  ///
  /// In en, this message translates to:
  /// **'Shared Ride'**
  String get activeTripsSharedRide;

  /// No description provided for @activeTripsCompanionBooking.
  ///
  /// In en, this message translates to:
  /// **'Companion Booking'**
  String get activeTripsCompanionBooking;

  /// No description provided for @activeTripsSelf.
  ///
  /// In en, this message translates to:
  /// **'Personal Ride'**
  String get activeTripsSelf;

  /// No description provided for @activeTripsTripId.
  ///
  /// In en, this message translates to:
  /// **'Trip #{id}'**
  String activeTripsTripId(int id);

  /// No description provided for @activeTripsRideRequestId.
  ///
  /// In en, this message translates to:
  /// **'Request #{id}'**
  String activeTripsRideRequestId(int id);

  /// No description provided for @activeTripsSharedRideId.
  ///
  /// In en, this message translates to:
  /// **'Room #{id}'**
  String activeTripsSharedRideId(int id);

  /// No description provided for @activeTripsPassengerId.
  ///
  /// In en, this message translates to:
  /// **'Passenger #{id}'**
  String activeTripsPassengerId(int id);

  /// No description provided for @activeTripsActiveSeats.
  ///
  /// In en, this message translates to:
  /// **'{count} Active Seats'**
  String activeTripsActiveSeats(int count);

  /// No description provided for @activeTripsAccountHolderOnBoard.
  ///
  /// In en, this message translates to:
  /// **'Account Holder On Board'**
  String get activeTripsAccountHolderOnBoard;

  /// No description provided for @activeTripsAccountHolderNotOnBoard.
  ///
  /// In en, this message translates to:
  /// **'Companion On Board'**
  String get activeTripsAccountHolderNotOnBoard;

  /// No description provided for @activeTripsStatusStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get activeTripsStatusStarted;

  /// No description provided for @activeTripsStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get activeTripsStatusInProgress;

  /// No description provided for @activeTripsStatusDriverArrived.
  ///
  /// In en, this message translates to:
  /// **'Driver Arrived'**
  String get activeTripsStatusDriverArrived;

  /// No description provided for @activeTripsStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Room'**
  String get activeTripsStatusOpen;

  /// No description provided for @activeTripsStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get activeTripsStatusReady;

  /// No description provided for @activeTripsStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get activeTripsStatusAccepted;

  /// No description provided for @activeTripsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Finding Driver'**
  String get activeTripsStatusPending;

  /// No description provided for @commonNoResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get commonNoResultsFound;

  /// No description provided for @unitKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitKm;

  /// No description provided for @unitMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitMin;

  /// No description provided for @unitStops.
  ///
  /// In en, this message translates to:
  /// **'stops'**
  String get unitStops;

  /// No description provided for @rideChooseYourRide.
  ///
  /// In en, this message translates to:
  /// **'Choose your ride'**
  String get rideChooseYourRide;

  /// No description provided for @rideCarType.
  ///
  /// In en, this message translates to:
  /// **'Car type'**
  String get rideCarType;

  /// No description provided for @rideNoCarTypesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No car types are available for this trip right now.'**
  String get rideNoCarTypesAvailable;

  /// No description provided for @sharedTripTryPoolInstead.
  ///
  /// In en, this message translates to:
  /// **'Try Passenger Pool Instead'**
  String get sharedTripTryPoolInstead;

  /// No description provided for @sharedTripRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed from Ride'**
  String get sharedTripRemovedTitle;

  /// No description provided for @sharedTripRemovedBody.
  ///
  /// In en, this message translates to:
  /// **'You were removed from this shared ride by the driver.'**
  String get sharedTripRemovedBody;

  /// No description provided for @sharedTripRemovedBodyReason.
  ///
  /// In en, this message translates to:
  /// **'You were removed from this shared ride by the driver.\n\nReason: {reason}'**
  String sharedTripRemovedBodyReason(String reason);

  /// No description provided for @sharedTripCanceledNotice.
  ///
  /// In en, this message translates to:
  /// **'The ride has been canceled.'**
  String get sharedTripCanceledNotice;

  /// No description provided for @sharedTripCanceledReason.
  ///
  /// In en, this message translates to:
  /// **'Trip Canceled: {reason}'**
  String sharedTripCanceledReason(String reason);

  /// No description provided for @sharedTripStartedNotice.
  ///
  /// In en, this message translates to:
  /// **'Trip has started! Tracking live route.'**
  String get sharedTripStartedNotice;

  /// No description provided for @sharedTripCompletedNotice.
  ///
  /// In en, this message translates to:
  /// **'Trip completed! Thank you for riding.'**
  String get sharedTripCompletedNotice;

  /// No description provided for @poolCreateNewLobby.
  ///
  /// In en, this message translates to:
  /// **'Create New Pool Lobby'**
  String get poolCreateNewLobby;

  /// No description provided for @poolCreateRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Pool Room'**
  String get poolCreateRoomTitle;

  /// No description provided for @poolYourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your Pool Journey'**
  String get poolYourJourney;

  /// No description provided for @poolLobbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pool Lobby #{id}'**
  String poolLobbyTitle(int id);

  /// No description provided for @poolDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure: {time}'**
  String poolDepartureTime(String time);

  /// No description provided for @poolWalkUnderOneMin.
  ///
  /// In en, this message translates to:
  /// **'< 1 min walk'**
  String get poolWalkUnderOneMin;

  /// No description provided for @poolWalkMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min walk'**
  String poolWalkMinutes(int minutes);

  /// No description provided for @poolOptimalMeetingPoint.
  ///
  /// In en, this message translates to:
  /// **'Optimal central meeting point'**
  String get poolOptimalMeetingPoint;

  /// No description provided for @poolOccupiedSeats.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} Seats'**
  String poolOccupiedSeats(int current, int total);

  /// No description provided for @poolPassengerNumber.
  ///
  /// In en, this message translates to:
  /// **'Passenger #{id}'**
  String poolPassengerNumber(int id);

  /// No description provided for @poolPassengerYou.
  ///
  /// In en, this message translates to:
  /// **'{name} (You)'**
  String poolPassengerYou(String name);

  /// No description provided for @poolHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get poolHost;

  /// No description provided for @poolSeatsRequested.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 seat requested} other{{count} seats requested}}'**
  String poolSeatsRequested(int count);

  /// No description provided for @poolWaitingForPassenger.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a passenger...'**
  String get poolWaitingForPassenger;

  /// No description provided for @poolStatusSwitchingTracking.
  ///
  /// In en, this message translates to:
  /// **'Switching to active ride tracking'**
  String get poolStatusSwitchingTracking;

  /// No description provided for @poolStatusRoomFullDriversNotified.
  ///
  /// In en, this message translates to:
  /// **'Room is full ({current}/{max}) • Drivers notified'**
  String poolStatusRoomFullDriversNotified(int current, int max);

  /// No description provided for @poolStatusPassengersJoined.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max} passengers joined'**
  String poolStatusPassengersJoined(int current, int max);

  /// No description provided for @poolDepartingSoon.
  ///
  /// In en, this message translates to:
  /// **'Departing soon'**
  String get poolDepartingSoon;

  /// No description provided for @poolDepartsAt.
  ///
  /// In en, this message translates to:
  /// **'Departs at {time}'**
  String poolDepartsAt(String time);

  /// No description provided for @poolSeatsOpen.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} seats open'**
  String poolSeatsOpen(int count, int max);

  /// No description provided for @poolHostedBy.
  ///
  /// In en, this message translates to:
  /// **'Hosted by {name}'**
  String poolHostedBy(String name);

  /// No description provided for @poolJoinPool.
  ///
  /// In en, this message translates to:
  /// **'Join Pool'**
  String get poolJoinPool;

  /// No description provided for @drawerWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get drawerWallet;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get walletBalance;

  /// No description provided for @walletStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get walletStatusActive;

  /// No description provided for @walletStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get walletStatusInactive;

  /// No description provided for @walletDetails.
  ///
  /// In en, this message translates to:
  /// **'Wallet Details'**
  String get walletDetails;

  /// No description provided for @walletId.
  ///
  /// In en, this message translates to:
  /// **'Wallet ID'**
  String get walletId;

  /// No description provided for @walletCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get walletCreatedAt;

  /// No description provided for @walletUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get walletUpdatedAt;

  /// No description provided for @walletErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallet'**
  String get walletErrorLoading;

  /// No description provided for @walletRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get walletRetry;

  /// No description provided for @walletTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get walletTransactions;

  /// No description provided for @walletTransactionsHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get walletTransactionsHistory;

  /// No description provided for @walletDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get walletDeposit;

  /// No description provided for @walletWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get walletWithdraw;

  /// No description provided for @walletTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get walletTransfer;

  /// No description provided for @walletTripPayment.
  ///
  /// In en, this message translates to:
  /// **'Trip Payment'**
  String get walletTripPayment;

  /// No description provided for @walletNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get walletNoTransactions;

  /// No description provided for @walletTapToViewTransactions.
  ///
  /// In en, this message translates to:
  /// **'Tap to view transactions'**
  String get walletTapToViewTransactions;

  /// No description provided for @walletBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after'**
  String get walletBalanceAfter;

  /// No description provided for @walletBalanceBefore.
  ///
  /// In en, this message translates to:
  /// **'Balance before'**
  String get walletBalanceBefore;

  /// No description provided for @unifiedTripAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get unifiedTripAll;

  /// No description provided for @unifiedTripDriverRides.
  ///
  /// In en, this message translates to:
  /// **'Driver Rides'**
  String get unifiedTripDriverRides;

  /// No description provided for @unifiedTripPoolLobbies.
  ///
  /// In en, this message translates to:
  /// **'Pool Lobbies'**
  String get unifiedTripPoolLobbies;

  /// No description provided for @unifiedTripDriverBadge.
  ///
  /// In en, this message translates to:
  /// **'Driver Ride'**
  String get unifiedTripDriverBadge;

  /// No description provided for @unifiedTripPoolBadge.
  ///
  /// In en, this message translates to:
  /// **'Passenger Pool'**
  String get unifiedTripPoolBadge;

  /// No description provided for @unifiedTripNoRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No rides or pools currently available'**
  String get unifiedTripNoRidesFound;

  /// No description provided for @unifiedTripNoDriverRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No driver shared rides found along this route'**
  String get unifiedTripNoDriverRidesFound;

  /// No description provided for @unifiedTripNoPoolLobbiesFound.
  ///
  /// In en, this message translates to:
  /// **'No passenger pools found along this route'**
  String get unifiedTripNoPoolLobbiesFound;

  /// No description provided for @unifiedTripCreatePoolCta.
  ///
  /// In en, this message translates to:
  /// **'Create a pool lobby to request a driver together'**
  String get unifiedTripCreatePoolCta;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodTitle;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodCashDesc.
  ///
  /// In en, this message translates to:
  /// **'Pay the driver in cash'**
  String get paymentMethodCashDesc;

  /// No description provided for @paymentMethodWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get paymentMethodWallet;

  /// No description provided for @paymentWalletAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance: {balance} {currency}'**
  String paymentWalletAvailableBalance(String balance, String currency);

  /// No description provided for @paymentWalletPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount} {currency} from Wallet'**
  String paymentWalletPayNow(String amount, String currency);

  /// No description provided for @paymentWalletSuccess.
  ///
  /// In en, this message translates to:
  /// **'Paid successfully from wallet'**
  String get paymentWalletSuccess;

  /// No description provided for @paymentWalletSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Deducted {amount} {currency}. Remaining balance: {balance} {currency}'**
  String paymentWalletSuccessDesc(
    String amount,
    String balance,
    String currency,
  );

  /// No description provided for @paymentWalletInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient wallet balance. Please choose cash.'**
  String get paymentWalletInsufficient;

  /// No description provided for @paymentPleasePayFirst.
  ///
  /// In en, this message translates to:
  /// **'Please complete wallet payment or choose cash'**
  String get paymentPleasePayFirst;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
