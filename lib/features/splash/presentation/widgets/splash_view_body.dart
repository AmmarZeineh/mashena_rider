import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/localization/locale_keys.dart';
import 'package:mashena_rider/core/network/network_info.dart';
import 'package:mashena_rider/core/theme/app_colors.dart';
import 'package:mashena_rider/core/utils/app_font_styles.dart';
import 'package:mashena_rider/core/utils/app_images.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _shimmerController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;

  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  late Animation<double> _shimmerAnimation;

  final NetworkInfo _networkInfo = NetworkInfoImpl();

  @override
  void initState() {
    super.initState();

    // Logo Animation Controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Text Animation Controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Shimmer Animation Controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Start animations and check connection
    _startAnimationsAndNavigate();
  }

  void _startAnimationsAndNavigate() async {
    // بدء الأنيميشنات
    await _logoController.forward();
    _textController.forward();
    _shimmerController.repeat();

    // انتظار مدة معينة لعرض الـ splash
    await Future.delayed(const Duration(seconds: 2));

    // فحص الاتصال بالإنترنت
    await _checkConnectionAndNavigate();
  }

  Future<void> _checkConnectionAndNavigate() async {
    if (!mounted) return;

    final isConnected = await _networkInfo.isConnected;

    if (!mounted) return;

    if (isConnected) {
      // في حال وجود اتصال، انتقل للواجهة التالية
      _navigateToNextScreen();
    } else {
      // في حال عدم وجود اتصال، أظهر رسالة
      _showNoInternetDialog();
    }
  }

  void _navigateToNextScreen() {
    GoRouter.of(context).goNamed(AppRoutes.onboarding);
    
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'لا يوجد اتصال بالإنترنت',
          style: AppTextStyles.w400_16.copyWith(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkConnectionAndNavigate();
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final logoSize = isSmallScreen ? 140.0 : 180.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
      ),
      child: Stack(
        children: [
          // Animated background circles
          _buildBackgroundCircles(size),

          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),

              // Logo with multiple animations
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Transform.rotate(
                        angle: _logoRotationAnimation.value,
                        child: _buildLogoWithShimmer(logoSize),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: size.height * 0.05),

              // Text with slide animation
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Text(
                      LocaleKeys.appDescription.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.w400_16.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.5,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.08),

              // Loading indicator
              FadeTransition(
                opacity: _textFadeAnimation,
                child: _buildLoadingIndicator(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoWithShimmer(double logoSize) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Colors.white,
                AppColors.primaryColor,
                Colors.white,
              ],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ],
              transform: GradientRotation(_shimmerAnimation.value),
            ).createShader(bounds);
          },
          child: Image.asset(
            Assets.imagesLogo,
            width: logoSize,
            height: logoSize,
          ),
        );
      },
    );
  }

  Widget _buildBackgroundCircles(Size size) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -size.height * 0.12,
              right: -size.width * 0.25,
              child: Opacity(
                opacity: _logoFadeAnimation.value * 0.1,
                child: Container(
                  width: size.width * 0.75,
                  height: size.width * 0.75,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.height * 0.18,
              left: -size.width * 0.35,
              child: Opacity(
                opacity: _logoFadeAnimation.value * 0.08,
                child: Container(
                  width: size.width,
                  height: size.width,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.primaryColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
