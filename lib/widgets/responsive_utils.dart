import 'package:flutter/material.dart';

class ResponsiveUtils {
  // نقاط التوقف القياسية
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;

  // 📱 التحقق من نوع الجهاز (حسب العرض)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMaxWidth;

  // 📏 مقاسات الشاشة
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double shortestSide(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide;

  // 📌 دوال مباشرة للاستخدام الأسرع
  static bool isMobileContext(BuildContext context) => isMobile(context);
  static bool isTabletContext(BuildContext context) => isTablet(context);
  static bool isDesktopContext(BuildContext context) => isDesktop(context);

  // 🔢 إرجاع قيمة متجاوبة لأي نوع بيانات عددية
  static double responsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? ((mobile + desktop) / 2);
    return desktop;
  }

  // 🔤 إرجاع حجم نص متجاوب
  static double responsiveTextSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double desktop,
  }) => responsiveValue(
    context,
    mobile: mobile,
    tablet: tablet,
    desktop: desktop,
  );

  // 🧩 عدد الأعمدة في Grid متجاوبة
  static int responsiveGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3; // Desktop
  }

  // 🛑 Padding متجاوب
  static EdgeInsets responsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    required EdgeInsets desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) {
      return tablet ?? EdgeInsets.lerp(mobile, desktop, 0.5)!;
    }
    return desktop;
  }

  // 🎨 BorderRadius متجاوب
  static BorderRadius responsiveBorderRadius(
    BuildContext context, {
    required BorderRadius mobile,
    BorderRadius? tablet,
    required BorderRadius desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) {
      return tablet ?? BorderRadius.lerp(mobile, desktop, 0.5)!;
    }
    return desktop;
  }
}
