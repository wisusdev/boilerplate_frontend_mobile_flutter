import 'package:flutter/material.dart';

class ResponsiveLayout {

    static double _getSize(BuildContext context, double mobile, double tablet, double desktop, double largeDesktop, isWidth) {
        final MediaQueryData mediaQuery = MediaQuery.of(context);
        final double size = isWidth ? mediaQuery.size.width : mediaQuery.size.height;

        if (isMobile(context)) {
            return size * mobile;
        } else if (isTablet(context)) {
            return size * tablet;
        } else if (isDesktop(context)) {
            return size * desktop;
        } else if (isLargeDesktop(context)) {
            return size * largeDesktop;
        }

        return size;
    }

    static containerMaxWidthSize(BuildContext context, {double mobile = 1, double tablet = 1, double desktop = 1, double largeDesktop = 1}) {
        return _getSize(context, mobile, tablet, desktop, largeDesktop, true);
    }

    static containerMaxHeightSize(BuildContext context, {double mobile = 1, double tablet = 1, double desktop = 1, double largeDesktop = 1}) {
        return _getSize(context, mobile, tablet, desktop, largeDesktop, false);
    }

    static bool isMobile(BuildContext context) {
        return MediaQuery.sizeOf(context).width < 600;
    }

    static bool isTablet(BuildContext context) {
        return MediaQuery.sizeOf(context).width >= 600 && MediaQuery.sizeOf(context).width < 1200;
    }

    static bool isDesktop(BuildContext context) {
        return MediaQuery.sizeOf(context).width >= 1200;
    }

    static bool isLargeDesktop(BuildContext context) {
        return MediaQuery.sizeOf(context).width >= 1800;
    }
}