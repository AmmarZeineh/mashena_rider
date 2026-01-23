import 'package:mashena_rider/core/utils/responsive_utils.dart';

extension ResponsiveNum on num {
  double get w => AppResponsive.w(toDouble());
  double get h => AppResponsive.h(toDouble());
  double get sp => AppResponsive.sp(toDouble());
  double get r => AppResponsive.r(toDouble());
  double get wp => AppResponsive.widthPercent(toDouble());
  double get hp => AppResponsive.heightPercent(toDouble());
}
