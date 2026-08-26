// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مشينا';

  @override
  String get appDescription => 'مرحبا بك في مشينا';

  @override
  String get commonOk => 'موافق';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get enableLocationBannerTitle => 'فعّل الموقع لتحديد موقعك تلقائيًا';

  @override
  String get enableLocationButton => 'تفعيل';

  @override
  String get locationServiceOffTitle => 'خدمة الموقع غير مفعّلة';

  @override
  String get openSettingsButton => 'فتح الإعدادات';

  @override
  String get commonYes => 'نعم';

  @override
  String get commonNo => 'لا';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonSkip => 'تخطي';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonSelected => 'مختار';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get commonError => 'حدث خطأ ما';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get onboardingTitle1 => 'احجز رحلتك في أي وقت';

  @override
  String get onboardingSubtitle1 =>
      'اعثر على سائق قريب واحجز رحلتك خلال ثوانٍ.';

  @override
  String get onboardingTitle2 => 'تتبّع سائقك مباشرة';

  @override
  String get onboardingSubtitle2 => 'شاهد موقع السائق ووقت وصوله لحظة بلحظة.';

  @override
  String get onboardingTitle3 => 'دفع سهل وآمن';

  @override
  String get onboardingSubtitle3 => 'ادفع نقدًا أو إلكترونيًا بكل أمان وراحة.';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get enterYourNumberLogin => 'ادخل رقمك لتسجيل الدخول';

  @override
  String get enterYourNumberRegister => 'Enter your number to sign up';

  @override
  String get enterYourEmailLogin => 'ادخل بريدك الالكتروني لتسجيل الدخول';

  @override
  String get enterYourEmailRegister => 'ادخل بريدك الالكتروني للتسجيل';

  @override
  String get enterDestination => 'ادخل وجهة';

  @override
  String get authRegister => 'إنشاء حساب';

  @override
  String get authLogout => 'تسجيل الخروج';

  @override
  String get authSendCode => 'ارسل رمز التحقق';

  @override
  String get authDontHaveAnAccount => 'ليس لديك حساب؟';

  @override
  String get authPhone => 'رقم الهاتف';

  @override
  String get authSignUp => 'تسجيل';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authOtpTitle => 'رمز التحقق';

  @override
  String get authOtpSubtitle => 'أدخل الرمز المرسل إلى رقمك';

  @override
  String get authResendOtp => 'إعادة إرسال الرمز';

  @override
  String get authOtpSuccess => 'تم تأكيد رمز التحقق';

  @override
  String get otpResendSuccess => 'تم ارسال رمز التحقق بنجاح';

  @override
  String get homeWhereTo => 'إلى أين تريد الذهاب؟';

  @override
  String get homeCurrentLocation => 'موقعي الحالي';

  @override
  String get homeSearchDestination => 'ابحث عن وجهة';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get makeSureInternetConnection =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';

  @override
  String get rideRequestRide => 'طلب رحلة';

  @override
  String get rideRequestSharedTrip => 'رحلة مشتركة';

  @override
  String get rideSharedTripSubtitle => 'شارك ووفر';

  @override
  String get sharedTripAvailableRooms => 'الرحلات المشتركة المتاحة';

  @override
  String get sharedTripSearchRooms => 'بحث';

  @override
  String get sharedTripChangeLocations => 'تعديل';

  @override
  String get sharedTripPickup => 'نقطة الانطلاق';

  @override
  String get sharedTripDestination => 'الوجهة';

  @override
  String get sharedTripSearchingRooms => 'جارٍ البحث عن رحلات مشتركة متاحة...';

  @override
  String get sharedTripNoRoomsFound =>
      'لا توجد رحلات مشتركة متاحة لهذا المسار حالياً.';

  @override
  String get sharedTripFarePerSeat => 'الأجرة للمقعد';

  @override
  String get sharedTripAvailableSeats => 'المقاعد المتاحة';

  @override
  String sharedTripSeatsCount(int available, int total) {
    return '$available من أصل $total مقاعد';
  }

  @override
  String get sharedTripDriver => 'السائق';

  @override
  String get sharedTripVehicle => 'المركبة';

  @override
  String get sharedTripDepartureTime => 'وقت الانطلاق';

  @override
  String sharedTripOriginDistance(String distance) {
    return 'يبعد $distance كم عن موقع انطلاقك';
  }

  @override
  String sharedTripDestDistance(String distance) {
    return 'يبعد $distance كم عن وجهتك';
  }

  @override
  String get currencySyp => 'ل.س';

  @override
  String get sharedTripStatusOpen => 'متاح';

  @override
  String get sharedTripRoomDetailsTitle => 'تفاصيل الرحلة';

  @override
  String get sharedTripRouteOverview => 'مسار الرحلة';

  @override
  String get sharedTripTotalDistance => 'المسافة الكلية';

  @override
  String get sharedTripEstDuration => 'المدة المتوقعة';

  @override
  String get sharedTripDriverNotes => 'ملاحظات وتعليمات السائق';

  @override
  String get sharedTripOccupancy => 'إشغال المقاعد';

  @override
  String sharedTripOccupiedSeats(int count) {
    return '$count محجوز';
  }

  @override
  String sharedTripFreeSeats(int count) {
    return '$count متاح';
  }

  @override
  String get sharedTripFullFare => 'أجرة المسار الكامل';

  @override
  String get sharedTripMinFare => 'الحد الأدنى للأجرة';

  @override
  String get sharedTripBaseCost => 'تكلفة الرحلة الأساسية';

  @override
  String get sharedTripJoinRoom => 'الانضمام إلى الرحلة';

  @override
  String get sharedTripRoomFull => 'الرحلة ممتلئة بالكامل';

  @override
  String get sharedTripRoomClosed => 'Trip is Closed';

  @override
  String get sharedTripPassengers => 'الركاب المنضمين';

  @override
  String get sharedTripNoNotes => 'لا توجد ملاحظات إضافية من السائق.';

  @override
  String get sharedTripSelectSeatsTitle => 'اختر عدد المقاعد';

  @override
  String get sharedTripSeatsNeeded => 'المقاعد المطلوبة';

  @override
  String get sharedTripJoinSuccess => 'تم الانضمام إلى الرحلة بنجاح!';

  @override
  String get sharedTripArrivedTitle => 'لقد وصلت إلى وجهتك!';

  @override
  String get sharedTripArrivedSubtitle => 'نتمنى أن تكون رحلتك ممتعة.';

  @override
  String get sharedTripBackToHome => 'العودة للرئيسية';

  @override
  String get sharedTripFinalFare => 'الأجرة النهائية';

  @override
  String get sharedTripConfirmJoin => 'تأكيد الانضمام';

  @override
  String get sharedTripLeaveRoom => 'مغادرة الرحلة المشتركة';

  @override
  String get sharedTripLeaveConfirmTitle => 'مغادرة الرحلة المشتركة؟';

  @override
  String get sharedTripLeaveConfirmBody =>
      'هل أنت متأكد من رغبتك في مغادرة الرحلة المشتركة؟ سيصبح مقعدك متاحاً للآخرين.';

  @override
  String get sharedTripLeaveSuccess => 'لقد غادرت الرحلة المشتركة بنجاح.';

  @override
  String sharedTripCompanionDropped(String fare, String currency) {
    return 'تم إنزال مرافق بنجاح. الأجرة: $fare $currency';
  }

  @override
  String get rideFindingDriver => 'جارٍ البحث عن سائق...';

  @override
  String get rideDriverOnWay => 'السائق في الطريق';

  @override
  String get rideDriverArrived => 'وصل السائق';

  @override
  String get rideTripStarted => 'بدأت الرحلة';

  @override
  String get rideTripEnded => 'انتهت الرحلة';

  @override
  String get rideCancelRide => 'إلغاء الرحلة';

  @override
  String get rideEstimatedTime => 'الوقت المتوقع';

  @override
  String get rideEstimatedPrice => 'السعر المتوقع';

  @override
  String get paymentPaymentMethod => 'طريقة الدفع';

  @override
  String get paymentCash => 'نقدًا';

  @override
  String get paymentOnline => 'دفع إلكتروني';

  @override
  String get paymentTotal => 'المجموع';

  @override
  String get paymentPayNow => 'ادفع الآن';

  @override
  String get paymentSuccess => 'تم الدفع بنجاح';

  @override
  String get paymentFailed => 'فشل الدفع';

  @override
  String get ratingRateDriver => 'قيّم السائق';

  @override
  String get ratingLeaveComment => 'اكتب تعليقًا (اختياري)';

  @override
  String get ratingSubmitRating => 'إرسال التقييم';

  @override
  String get profileProfile => 'الملف الشخصي';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileName => 'الاسم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileNotifications => 'الإشعارات';

  @override
  String get profilePrivacy => 'الخصوصية';

  @override
  String get settingsSettings => 'الإعدادات';

  @override
  String get settingsDarkMode => 'الوضع الليلي';

  @override
  String get settingsChangeLanguage => 'تغيير اللغة';

  @override
  String get settingsAboutApp => 'حول التطبيق';

  @override
  String get errorsNetwork => 'تحقق من اتصال الإنترنت';

  @override
  String get errorsUnauthorized => 'غير مصرح لك';

  @override
  String get errorsLocationPermission => 'يرجى السماح بالوصول إلى الموقع';

  @override
  String get apiConnectionTimeout => 'انتهت مهلة الاتصال';

  @override
  String get apiSendTimeout => 'انتهت مهلة الإرسال';

  @override
  String get apiReceiveTimeout => 'انتهت مهلة الاستلام';

  @override
  String get apiRequestCancelled => 'تم إلغاء الطلب';

  @override
  String get apiConnectionError => 'خطأ في الاتصال';

  @override
  String get apiCertificateError => 'خطأ في الشهادة';

  @override
  String get apiBadRequest => 'طلب غير صالح';

  @override
  String get apiUnauthorized => 'غير مصرح';

  @override
  String get apiForbidden => 'ممنوع';

  @override
  String get apiNotFound => 'غير موجود';

  @override
  String get apiValidationError => 'خطأ في التحقق من البيانات';

  @override
  String get apiServerError => 'خطأ في الخادم';

  @override
  String get apiBadGateway => 'بوابة غير صالحة';

  @override
  String get apiServiceUnavailable => 'الخدمة غير متاحة';

  @override
  String apiRequestFailed(Object code) {
    return 'فشل الطلب ($code)';
  }

  @override
  String get otpTitle => 'أدخل رمز التحقق';

  @override
  String get alreadyHaveAnAccount => 'لديك حساب؟';

  @override
  String get confirmPassword => 'تاكيد كلمة المرور';

  @override
  String otpSubtitle(Object phone) {
    return 'تم إرسال رمز إلى $phone';
  }

  @override
  String get otpDidNotReceive => 'لم يصلك الرمز؟';

  @override
  String get otpResend => 'إعادة الإرسال';

  @override
  String get otpVerifyNow => 'تحقق الآن';

  @override
  String get apiUnknownError => 'خطأ غير معروف';

  @override
  String get cacheError => 'خطأ في التخزين';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationInvalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get validationInvalidPhone => 'رقم هاتف غير صالح';

  @override
  String get validationWeakPassword =>
      'كلمة مرور ضعيفة (حرف كبير، صغير، رقم، رمز)';

  @override
  String get validationOtpInvalid => 'رمز غير صالح';

  @override
  String validationMinLength(int min) {
    return 'الحد الأدنى $min أحرف';
  }

  @override
  String get validationPasswordsNotMatch => 'Passwords do not match';

  @override
  String validationMaxLength(int max) {
    return 'الحد الأقصى $max أحرف';
  }

  @override
  String get locationPermissionRationaleTitle => 'الوصول إلى الموقع';

  @override
  String get locationPermissionRationaleBody =>
      'يحتاج تطبيق مشينا إلى موقعك لعرض موقعك على الخريطة، وتحديد نقطة الالتقاط تلقائيًا، وربطك بالسائقين القريبين.';

  @override
  String get locationPermissionAllow => 'السماح';

  @override
  String get locationPermissionDeniedForeverTitle => 'إذن الموقع مطلوب';

  @override
  String get locationPermissionDeniedForeverBody =>
      'لقد رفضت إذن الموقع بشكل دائم. يرجى فتح الإعدادات وتفعيله يدويًا.';

  @override
  String get mapDragToMovePin => 'اسحب الخريطة لتحريك المؤشر';

  @override
  String get mapConfirmLocation => 'تأكيد الموقع';

  @override
  String get homeNowYouCanAddMultipleStops => 'الآن يمكنك إضافة عدة وجهات';

  @override
  String get rideAvailableRides => 'الرحلات المتاحة';

  @override
  String get rideBookRide => 'احجز رحلة';

  @override
  String get rideNoTypesAvailable => 'لا توجد أنواع رحلات متاحة الآن.';

  @override
  String rideDistanceKm(String distance) {
    return '$distance كم';
  }

  @override
  String rideDurationMin(String duration) {
    return '$duration دقيقة';
  }

  @override
  String rideStopsCount(int count) {
    return '$count محطة';
  }

  @override
  String get ridePersonCapacity => '4+1 شخص';

  @override
  String get homeMapRouteUnavailable =>
      'مسار الخريطة غير متاح حالياً. العلامات توضح توقفات رحلتك.';

  @override
  String get rideConfirmed => 'تم تأكيد الرحلة';

  @override
  String get driverRating => 'التقييم';

  @override
  String get driverTrips => 'الرحلات';

  @override
  String get driverYears => 'سنوات';

  @override
  String get driverVehicleDetails => 'تفاصيل المركبة';

  @override
  String get driverLicensePlate => 'رقم اللوحة';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get rideEstFare => 'السعر التقديري';

  @override
  String get rideDistance => 'المسافة';

  @override
  String get rideDuration => 'المدة';

  @override
  String get commonPleaseWait => 'يرجى الانتظار';

  @override
  String get rideLookingForDrivers => 'جارٍ البحث عن سائقين قريبين...';

  @override
  String get rideTakesFewMoments => 'يستغرق هذا عادة بضع لحظات';

  @override
  String get simulateEndTrip => 'محاكاة إنهاء الرحلة';

  @override
  String get tripCancelledByDriver => 'تم إلغاء الرحلة من قبل السائق';

  @override
  String get tripCancelledByAdmin => 'تم إلغاء الرحلة من قبل الإدارة';

  @override
  String get tripCancelled => 'تم إلغاء الرحلة';

  @override
  String get tripCancelledSubtitleDriver =>
      'قام السائق بإلغاء طلب الرحلة. يمكنك طلب رحلة جديدة في أي وقت.';

  @override
  String get tripCancelledSubtitleAdmin =>
      'تم إلغاء الرحلة من قبل إدارة النظام.';

  @override
  String get tripCancelledSubtitleGeneral => 'تم إلغاء طلب الرحلة الحالي.';

  @override
  String get noCancellationFeeNotice => 'لم يتم خصم أي رسوم إلغاء لهذه الرحلة.';

  @override
  String get logoutConfirmationMessage =>
      'هل ترغب في تسجيل الخروج من هذا الجهاز أو جميع الأجهزة؟';

  @override
  String get logoutThisDevice => 'هذا الجهاز';

  @override
  String get logoutAllDevices => 'جميع الأجهزة';

  @override
  String get drawerMyAccount => 'حسابي';

  @override
  String get drawerFavourites => 'المفضلة';

  @override
  String get drawerFaq => 'الأسئلة الشائعة';

  @override
  String get drawerSos => 'الطوارئ';

  @override
  String get drawerMakeComplaints => 'تقديم شك≥وى';

  @override
  String get drawerNotification => 'الإشعارات';

  @override
  String get drawerAbout => 'عن التطبيق';

  @override
  String get drawerPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get drawerTermsCondition => 'الشروط والأحكام';

  @override
  String get drawerGuestUser => 'مستخدم زائر';

  @override
  String get rideLoadingDriverDetails => 'جاري تحميل تفاصيل السائق...';

  @override
  String rideVehicleModelAndColor(String vehicleModel, String vehicleColor) {
    return '$vehicleModel • $vehicleColor';
  }

  @override
  String get rideDriverArrivedAtPickup => 'وصل السائق إلى نقطة الانطلاق!';

  @override
  String get rideWaitingChargesWarning =>
      '⚠️ قد يتم تطبيق رسوم انتظار بعد انتهاء وقت الانتظار المجاني.';

  @override
  String get rideInProgressHeadingToDestination =>
      'قيد التقدم • متوجه إلى الوجهة';

  @override
  String get rideWaitingChargesApplying =>
      '⏱️ 00:00 • يتم الآن تطبيق رسوم الانتظار';

  @override
  String rideFreeWaitingTime(String minutes, String seconds) {
    return '⏱️ وقت الانتظار المجاني: $minutes:$seconds';
  }

  @override
  String get rideVehicleDefault => 'مركبة';

  @override
  String get rideVehicleStandard => 'قياسي';

  @override
  String rideVehicleColorAndType(String color, String type) {
    return '$color • $type';
  }

  @override
  String get drawerCoupons => 'الكوبونات';

  @override
  String get applyCouponTitle => 'إدخال كود الكوبون';

  @override
  String get enterCouponHint => 'أدخل كود الكوبون';

  @override
  String get applyButton => 'تطبيق';

  @override
  String get activeCouponsSection => 'الكوبونات المفعلة';

  @override
  String get couponHistorySection => 'سجل الكوبونات';

  @override
  String get noActiveCoupons => 'لا توجد كوبونات مفعلة حالياً';

  @override
  String get noCouponHistory => 'لا يوجد سجل للكوبونات';

  @override
  String remainingUsages(num count) {
    return 'متبقي $count استخدامات';
  }

  @override
  String get couponStatusActive => 'مفعل';

  @override
  String get couponStatusUsed => 'مُستخدم';

  @override
  String get couponStatusExpired => 'منتهي';

  @override
  String expiresOn(String date) {
    return 'ينتهي في $date';
  }

  @override
  String get couponAppliedSuccess => 'تم تطبيق الكوبون بنجاح';

  @override
  String get enterValidCouponCode => 'يرجى إدخال كود الكوبون';

  @override
  String get appCurrency => 'ل.س';

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
  String get rideExpiredTitle => 'انتهت صلاحية طلب الرحلة';

  @override
  String get rideExpiredSubtitle =>
      'لم يكن هناك سائقون متاحون في منطقتك. يرجى المحاولة مرة أخرى.';

  @override
  String get drawerTripHistory => 'سجل الرحلات';

  @override
  String get tripHistoryTitle => 'سجل الرحلات';

  @override
  String get noTripHistory => 'لا يوجد سجل رحلات';

  @override
  String get statusCompleted => 'مكتملة';

  @override
  String get statusCancelled => 'ملغاة';

  @override
  String get statusInProgress => 'قيد التنفيذ';

  @override
  String get commonAll => 'الكل';

  @override
  String get ratingPleaseSelectScore => 'يرجى اختيار تقييم بالنجوم';

  @override
  String get ratingPleaseSelectTag => 'يرجى اختيار وسم واحد على الأقل';

  @override
  String get ratingDontRate => 'عدم التقييم';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptySubtitle =>
      'سنرسل إليك إشعاراً عند وجود أي تحديثات جديدة';

  @override
  String unreadNotificationsBadge(int count) {
    return '$count غير مقروء';
  }

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String notificationTripId(int id) {
    return 'رحلة #$id';
  }

  @override
  String notificationRideRequestId(int id) {
    return 'طلب #$id';
  }

  @override
  String get poolTransport => 'النقل التشاركي';

  @override
  String get poolFindLobby => 'البحث عن غرفة تجمع';

  @override
  String get poolCreateLobby => 'إنشاء غرفة تجمع';

  @override
  String get poolPublishLobby => 'نشر غرفة التجمع';

  @override
  String get poolMatchingNearby => 'غرف التجمع القريبة المتطابقة';

  @override
  String get poolSearchingLobbies => 'جاري البحث عن غرف تجمع متطابقة...';

  @override
  String get poolNoLobbiesFound => 'لم يتم العثور على غرف تجمع';

  @override
  String get poolNoLobbiesFoundSubtitle =>
      'كن أول من ينشئ غرفة تجمع لينضم إليك ركاب آخرون بنفس وجهتك!';

  @override
  String get poolMeetingPoint => 'نقطة الالتقاء المشتركة';

  @override
  String get poolMeetingPointDesc =>
      'توجه سيراً إلى هنا لمقابلة السائق والركاب';

  @override
  String get poolPassengersRoster => 'قائمة الركاب';

  @override
  String get poolTargetDepartureTime => 'وقت الانطلاق المستهدف';

  @override
  String get poolTotalCapacity => 'إجمالي سعة الركاب';

  @override
  String get poolCapacityDesc =>
      'سيتم إرسال الغرفة للسائقين فور اكتمال الركاب.';

  @override
  String get poolSeatsYouNeed => 'المقاعد المطلوبة';

  @override
  String get poolSeatsYouNeedDesc => 'عدد المقاعد لك ولمرافقيك';

  @override
  String get poolJoinSuccess => 'تم الانضمام إلى غرفة التجمع بنجاح!';

  @override
  String get poolCreateSuccess =>
      'تم إنشاء غرفة التجمع! بانتظار الركاب في اللوبي.';

  @override
  String get poolCancelRoom => 'إلغاء غرفة التجمع';

  @override
  String get poolLeaveRoom => 'مغادرة غرفة التجمع';

  @override
  String get poolCancelConfirmTitle => 'إلغاء غرفة التجمع؟';

  @override
  String get poolCancelConfirmBody =>
      'سيؤدي إلغاء الغرفة إلى حل غرفة التجمع وإشعار جميع الركاب المنضمين.';

  @override
  String get poolLeaveConfirmTitle => 'مغادرة غرفة التجمع؟';

  @override
  String get poolLeaveConfirmBody =>
      'هل أنت متأكد من رغبتك في مغادرة غرفة التجمع؟ سيصبح مقعدك متاحاً للآخرين.';

  @override
  String get poolDriverFound => 'تم العثور على سائق! تبدأ رحلتك الآن.';

  @override
  String get poolExpiredTitle => 'انتهت صلاحية غرفة التجمع';

  @override
  String get poolExpiredBody =>
      'لم يتم قبول أي سائق للرحلة قبل وقت الانطلاق. انتهت صلاحية الغرفة.';

  @override
  String get poolCancelledTitle => 'تم إلغاء غرفة التجمع';

  @override
  String get poolCancelledBody => 'قام منشئ الغرفة بإلغائها.';

  @override
  String get poolRemovedTitle => 'تمت إزالتك من الغرفة';

  @override
  String get poolRemovedBody => 'تمت إزالتك من غرفة التجمع هذه.';

  @override
  String get poolStatusLooking => 'بانتظار انضمام الركاب';

  @override
  String get poolStatusReady => 'جاري البحث عن سائق...';

  @override
  String get poolStatusMatched => 'تم تعيين السائق!';

  @override
  String get drawerModeration => 'الرقابة والقيود';

  @override
  String get moderationTitle => 'حالة الحساب والرقابة';

  @override
  String get moderationOverviewTab => 'نظرة عامة';

  @override
  String get moderationPenaltiesTab => 'العقوبات';

  @override
  String get moderationViolationsTab => 'المخالفات';

  @override
  String get moderationAppealsTab => 'الاعتراضات';

  @override
  String get moderationAccountStatus => 'حالة الحساب';

  @override
  String get moderationStatusActive => 'حساب سليم ونشط';

  @override
  String get moderationStatusWarning => 'يوجد تنبيه مسجل';

  @override
  String get moderationStatusRestricted => 'مقيد جزئياً';

  @override
  String get moderationStatusSuspended => 'معلق مؤقتاً';

  @override
  String get moderationStatusBanned => 'محظور نهائياً';

  @override
  String get moderationActiveRestrictions => 'القيود السارية';

  @override
  String get moderationActivePenalties => 'العقوبات السارية';

  @override
  String get moderationRecentViolations => 'أحدث المخالفات';

  @override
  String get moderationActiveAppeals => 'الاعتراضات النشطة';

  @override
  String get moderationWarningsCount => 'الإنذارات';

  @override
  String get moderationViolationsCount => 'إجمالي المخالفات';

  @override
  String get moderationPenaltiesCount => 'عقوبات سارية';

  @override
  String get moderationRestrictionsCount => 'القيود الفعالة';

  @override
  String get moderationSubmitAppeal => 'تقديم اعتراض';

  @override
  String get moderationAppealReason => 'سبب الاعتراض';

  @override
  String get moderationAppealReasonHint =>
      'اشرح بالتفصيل سبب الاعتراض ولماذا يجب إعادة النظر في العقوبة...';

  @override
  String get moderationAppealEvidence => 'رابط الإثبات أو الدليل (اختياري)';

  @override
  String get moderationAppealEvidenceHint => 'https://example.com/proof.jpg';

  @override
  String get moderationAppealSubmitBtn => 'إرسال الاعتراض';

  @override
  String get moderationAppealSubmitting => 'جاري إرسال الاعتراض...';

  @override
  String get moderationAppealSuccess => 'تم تقديم طلب الاعتراض بنجاح';

  @override
  String get moderationAppealAlreadyExists =>
      'يوجد اعتراض قيد المراجعة بالفعل لهذه العقوبة';

  @override
  String get moderationPenaltyNotAppealable =>
      'يمكن الاعتراض فقط على العقوبات السارية والفعالة';

  @override
  String get moderationAppealDetailsTitle => 'تفاصيل الاعتراض';

  @override
  String get moderationAdminDecision => 'قرار الإدارة';

  @override
  String get moderationAdminNotes => 'ملاحظات الإدارة';

  @override
  String moderationExpiresAt(String date) {
    return 'ينتهي في: $date';
  }

  @override
  String moderationStartsAt(String date) {
    return 'بدأ في: $date';
  }

  @override
  String moderationIssuedAt(String date) {
    return 'صدر في: $date';
  }

  @override
  String moderationSubmittedAt(String date) {
    return 'تاريخ التقديم: $date';
  }

  @override
  String moderationReviewedAt(String date) {
    return 'تاريخ المراجعة: $date';
  }

  @override
  String get moderationNoPenalties => 'لا توجد عقوبات مسجلة';

  @override
  String get moderationNoViolations => 'لا توجد مخالفات مسجلة';

  @override
  String get moderationNoAppeals => 'لا توجد طلبات اعتراض مقدمة';

  @override
  String get moderationNoRestrictions => 'لا توجد قيود مفعلة على حسابك';

  @override
  String get moderationPermanentBanNotice => 'حظر دائم (بدون تاريخ انتهاء)';

  @override
  String get moderationPenaltyTypeWarning => 'إنذار / تنبيه';

  @override
  String get moderationPenaltyTypeSuspension => 'تعليق مؤقت';

  @override
  String get moderationPenaltyTypeBan => 'حظر دائم';

  @override
  String get moderationPenaltyTypeFeatureRestriction => 'تقييد ميزة معينة';

  @override
  String get moderationPenaltyTypeAccountRestriction => 'تقييد شامل للحساب';

  @override
  String get moderationPenaltyStatusActive => 'سارية';

  @override
  String get moderationPenaltyStatusExpired => 'منتهية الصلاحية';

  @override
  String get moderationPenaltyStatusRevoked => 'تم رفعها وإلغاؤها';

  @override
  String get moderationPenaltyStatusCancelled => 'ملغاة';

  @override
  String get moderationRestrictionRequestRide => 'طلب المشاوير العادية';

  @override
  String get moderationRestrictionJoinSharedRide => 'المشاوير المشتركة';

  @override
  String get moderationRestrictionJoinPassengerPool => 'غرف تجمع الركاب';

  @override
  String get moderationRestrictionWalletTransfer => 'تحويل رصيد المحفظة';

  @override
  String get moderationRestrictionPayment => 'عمليات الدفع';

  @override
  String get moderationRestrictionFullAccount => 'تجميد الحساب بالكامل';

  @override
  String get moderationViolationRiderTripCancellation =>
      'إلغاء المشوار بعد قبوله';

  @override
  String get moderationViolationNoShow => 'عدم الحضور لنقطة الانطلاق';

  @override
  String get moderationViolationLateCancellation => 'إلغاء متأخر للمشوار';

  @override
  String get moderationViolationSharedRideMisuse =>
      'إساءة استخدام المشاوير المشتركة';

  @override
  String get moderationViolationPassengerPoolMisuse =>
      'إساءة استخدام غرف الركاب';

  @override
  String get moderationViolationPaymentAbuse => 'احتيال أو مشاكل دفع';

  @override
  String get moderationViolationWalletAbuse => 'إساءة استخدام المحفظة';

  @override
  String get moderationViolationAbusiveBehavior => 'سلوك غير لائق ومسيء';

  @override
  String get moderationViolationFraud => 'نشاط احتيالي مشبوه';

  @override
  String get moderationViolationManualAdmin => 'مخالفة إدارية مسجلة';

  @override
  String get moderationSeverityLow => 'منخفض';

  @override
  String get moderationSeverityMedium => 'متوسط';

  @override
  String get moderationSeverityHigh => 'مرتفع';

  @override
  String get moderationSeverityCritical => 'حرج';

  @override
  String get moderationAppealStatusPending => 'قيد الانتظار';

  @override
  String get moderationAppealStatusUnderReview => 'قيد المراجعة والتدقيق';

  @override
  String get moderationAppealStatusApproved => 'تم قبول الاعتراض';

  @override
  String get moderationAppealStatusRejected => 'تم رفض الاعتراض';

  @override
  String get moderationAppealStatusCancelled => 'ملغى';

  @override
  String get moderationReasonRequired => 'يرجى كتابة سبب الاعتراض';

  @override
  String get moderationReasonTooLong =>
      'لا يمكن أن يتجاوز سبب الاعتراض 2000 حرف';

  @override
  String get moderationInvalidEvidenceUrl => 'يرجى إدخال رابط صالح';

  @override
  String moderationPenaltyRef(int id) {
    return 'عقوبة #$id';
  }

  @override
  String moderationAppealRef(int id) {
    return 'اعتراض #$id';
  }

  @override
  String get moderationRealtimePenaltyTitle => 'تنبيه رقابي جديد';

  @override
  String get moderationRealtimeLiftedTitle => 'تم رفع القيد بنجاح';
}
