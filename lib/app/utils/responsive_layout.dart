import 'package:flutter/material.dart';

class Responsive {
    static const int mobileBreakpoint = 576;
    static const int tabletBreakpoint = 768;
    static const int desktopBreakpoint = 992;
    static const int largeDesktopBreakpoint = 1200;

    static containerMaxWidthSize(BuildContext context, BoxConstraints constraints, {double mobile = 1, double tablet = 1, double desktop = 1, double largeDesktop = 1}) {
        if (isMobile(context)) {
            return constraints.maxWidth * mobile;
        } else if (isTablet(context)) {
            return constraints.maxWidth * tablet;
        } else if (isDesktop(context)) {
            return constraints.maxWidth * desktop;
        } else if (isLargeDesktop(context)) {
            return constraints.maxWidth * largeDesktop;
        }
    }

    static bool isMobile(BuildContext context) {
        return MediaQuery.of(context).size.width < mobileBreakpoint;
    }

    static bool isTablet(BuildContext context) {
        return MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
    }

    static bool isDesktop(BuildContext context) {
        return MediaQuery.of(context).size.width >= tabletBreakpoint && MediaQuery.of(context).size.width < desktopBreakpoint;
    }

    static bool isLargeDesktop(BuildContext context) {
        return MediaQuery.of(context).size.width >= desktopBreakpoint;
    }
}