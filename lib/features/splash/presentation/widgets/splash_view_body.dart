import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mashena_rider/app/di/injector.dart';
import 'package:mashena_rider/app/router/app_routes.dart';
import 'package:mashena_rider/core/constants/app_constants.dart';
import 'package:mashena_rider/core/l10n/app_localizations.dart';
import 'package:mashena_rider/core/network/network_info.dart';
import 'package:mashena_rider/core/storage/local_storage.dart';
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
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _shimmerController;

  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotationAnimation;

  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;

  late final Animation<double> _shimmerAnimation;

  // الأفضل: خليه من DI، بس هون خليته مثل ما عندك
  final NetworkInfo _networkInfo = NetworkInfoImpl();

  @override
  void initState() {
    super.initState();

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

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // ابدأ بعد أول frame لتجنب أي مشاكل context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationsAndNavigate();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final storage = getIt<LocalStorage>();
    final onboardingSeen =
        storage.getBool(AppConstants.isOnboardingSeenKey) ?? false;

    if (onboardingSeen) {
      context.go(AppRoutes.loginPath);
    } else {
      context.go(AppRoutes.onboardingPath);
    }
  }

  Future<void> _startAnimationsAndNavigate() async {
    await _logoController.forward();
    _textController.forward();
    _shimmerController.repeat();

    await Future.delayed(const Duration(seconds: 2));
    await _checkConnectionAndNavigate();
  }

  Future<void> _checkConnectionAndNavigate() async {
    if (!mounted) return;

    final isConnected = await _networkInfo.isConnected;
    if (!mounted) return;

    if (!isConnected) {
      _showNoInternetDialog();
    }
    if (isConnected) {
      _navigate();
    }
  }

  void _showNoInternetDialog() {
    final s = S.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        final cs = theme.colorScheme;

        return AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
            // إذا ما عندك key خاص، خليها مؤقتًا هيك أو أضف key بالـ ARB
            // s.errorsNetwork (غير مناسب كعنوان) لذلك خليت نص عربي fallback
            'لا يوجد اتصال بالإنترنت',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          content: Text(
            'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _checkConnectionAndNavigate();
              },
              child: Text(
                s.commonRetry, // موجود عندك
                style: theme.textTheme.labelLarge?.copyWith(color: cs.primary),
              ),
            ),
          ],
        );
      },
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
    final s = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final logoSize = isSmallScreen ? 140.0 : 180.0;

    // خلفية تتبع الثيم
    final bg1 = cs.surface; // غالبًا أبيض بالـ light، داكن بالـ dark
    final bg2 = cs.surfaceContainerHighest; // درجة ثانية مريحة

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg1, bg2],
        ),
      ),
      child: Stack(
        children: [
          _buildBackgroundCircles(size, cs),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),

              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _logoFadeAnimation,
                    child: ScaleTransition(
                      scale: _logoScaleAnimation,
                      child: Transform.rotate(
                        angle: _logoRotationAnimation.value,
                        child: _buildLogoWithShimmer(
                          logoSize: logoSize,
                          colorScheme: cs,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: size.height * 0.05),

              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Text(
                      s.appDescription,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.w400_16.copyWith(
                        color: cs.onSurface.withOpacity(0.75),
                        height: 1.5,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.08),

              FadeTransition(
                opacity: _textFadeAnimation,
                child: _buildLoadingIndicator(cs),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoWithShimmer({
    required double logoSize,
    required ColorScheme colorScheme,
  }) {
    // إذا عندك AppColors.primaryColor ثابت، ممكن تستخدم colorScheme.primary أفضل
    final primary = AppColors.primaryColor;

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.surface, primary, colorScheme.surface],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ],
              transform: GradientRotation(_shimmerAnimation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset(
            Assets.imagesLogo,
            width: logoSize,
            height: logoSize,
          ),
        );
      },
    );
  }

  Widget _buildBackgroundCircles(Size size, ColorScheme cs) {
    final primary = cs.primary;
    final onSurface = cs.onSurface;

    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -size.height * 0.12,
              right: -size.width * 0.25,
              child: Opacity(
                opacity: _logoFadeAnimation.value * 0.10,
                child: Container(
                  width: size.width * 0.75,
                  height: size.width * 0.75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.height * 0.18,
              left: -size.width * 0.35,
              child: Opacity(
                opacity: _logoFadeAnimation.value * 0.07,
                child: Container(
                  width: size.width,
                  height: size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                ),
              ),
            ),

            // دائرة خفيفة إضافية (تعطي عمق، تتبع الثيم)
            Positioned(
              top: size.height * 0.22,
              left: -size.width * 0.20,
              child: Opacity(
                opacity: _logoFadeAnimation.value * 0.04,
                child: Container(
                  width: size.width * 0.55,
                  height: size.width * 0.55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onSurface,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator(ColorScheme cs) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
