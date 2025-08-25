import 'package:flutter/material.dart';

/// Enumeración para tipos de dispositivo
enum DeviceType { mobile, tablet, desktop, largeDesktop, tv }

/// Enumeración para orientación
enum DeviceOrientation { portrait, landscape }

/// Clase principal para manejo de responsive design
class Responsive {
  // Breakpoints optimizados para diferentes dispositivos
  static const int mobileBreakpoint = 576;
  static const int tabletBreakpoint = 768;
  static const int desktopBreakpoint = 1024;
  static const int largeDesktopBreakpoint = 1440;
  static const int tvBreakpoint = 1920;

  // Breakpoints para altura (útil para TV y orientación)
  static const int mobileHeightBreakpoint = 812;
  static const int tabletHeightBreakpoint = 1024;
  static const int tvHeightBreakpoint = 1080;

  /// Obtiene el tipo de dispositivo basado en las dimensiones de pantalla
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    // Detectar TV (resoluciones típicas de TV)
    if (width >= tvBreakpoint || height >= tvHeightBreakpoint) {
      return DeviceType.tv;
    }
    
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else if (width < largeDesktopBreakpoint) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  /// Obtiene la orientación del dispositivo
  static DeviceOrientation getOrientation(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height 
        ? DeviceOrientation.landscape 
        : DeviceOrientation.portrait;
  }

  /// Calcula el ancho máximo del contenedor basado en el dispositivo
  static double containerMaxWidthSize(
    BuildContext context, 
    BoxConstraints constraints, {
    double mobile = 1.0,
    double tablet = 0.9,
    double desktop = 0.8,
    double largeDesktop = 0.7,
    double tv = 0.85,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return constraints.maxWidth * mobile;
      case DeviceType.tablet:
        return constraints.maxWidth * tablet;
      case DeviceType.desktop:
        return constraints.maxWidth * desktop;
      case DeviceType.largeDesktop:
        return constraints.maxWidth * largeDesktop;
      case DeviceType.tv:
        return constraints.maxWidth * tv;
    }
  }

  /// Obtiene el número de columnas para grids basado en el dispositivo
  static int getGridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int largeDesktop = 4,
    int tv = 5,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.tv:
        return tv;
    }
  }

  /// Obtiene padding responsivo
  static EdgeInsets getPadding(BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(8.0),
    EdgeInsets tablet = const EdgeInsets.all(16.0),
    EdgeInsets desktop = const EdgeInsets.all(24.0),
    EdgeInsets largeDesktop = const EdgeInsets.all(32.0),
    EdgeInsets tv = const EdgeInsets.all(40.0),
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.tv:
        return tv;
    }
  }

  /// Obtiene espaciado responsivo
  static double getSpacing(BuildContext context, {
    double mobile = 8.0,
    double tablet = 12.0,
    double desktop = 16.0,
    double largeDesktop = 20.0,
    double tv = 24.0,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.tv:
        return tv;
    }
  }

  /// Obtiene factor de escala para texto
  static double getTextScaleFactor(BuildContext context, {
    double mobile = 1.0,
    double tablet = 1.1,
    double desktop = 1.0,
    double largeDesktop = 1.1,
    double tv = 1.3,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.tv:
        return tv;
    }
  }

  // Métodos de conveniencia para verificar tipos de dispositivo
  static bool isMobile(BuildContext context) => getDeviceType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) => getDeviceType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) => getDeviceType(context) == DeviceType.desktop;
  static bool isLargeDesktop(BuildContext context) => getDeviceType(context) == DeviceType.largeDesktop;
  static bool isTV(BuildContext context) => getDeviceType(context) == DeviceType.tv;
  
  // Verificaciones de orientación
  static bool isPortrait(BuildContext context) => getOrientation(context) == DeviceOrientation.portrait;
  static bool isLandscape(BuildContext context) => getOrientation(context) == DeviceOrientation.landscape;
  
  // Verificaciones combinadas útiles
  static bool isMobileOrTablet(BuildContext context) => isMobile(context) || isTablet(context);
  static bool isDesktopOrLarger(BuildContext context) => isDesktop(context) || isLargeDesktop(context) || isTV(context);
  static bool isTouchDevice(BuildContext context) => isMobile(context) || isTablet(context);
  
  /// Verifica si el dispositivo soporta input de teclado/mouse
  static bool supportsKeyboardMouse(BuildContext context) {
    return isDesktop(context) || isLargeDesktop(context) || isTV(context);
  }

  /// Verifica si necesita navegación especial para TV
  static bool needsTVNavigation(BuildContext context) {
    return isTV(context);
  }

  /// Obtiene el factor de escala para iconos
  static double getIconScale(BuildContext context, {
    double mobile = 1.0,
    double tablet = 1.2,
    double desktop = 1.0,
    double largeDesktop = 1.1,
    double tv = 1.5,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.tv:
        return tv;
    }
  }

  /// Ejecuta función específica según el tipo de dispositivo
  static T when<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
    T? tv,
  }) {
    switch (getDeviceType(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
      case DeviceType.tv:
        return tv ?? largeDesktop ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Información de debug sobre el dispositivo actual
  static Map<String, dynamic> getDeviceInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    return {
      'width': size.width,
      'height': size.height,
      'deviceType': getDeviceType(context).toString(),
      'orientation': getOrientation(context).toString(),
      'devicePixelRatio': devicePixelRatio,
      'textScaleFactor': getTextScaleFactor(context),
      'isTouchDevice': isTouchDevice(context),
      'supportsKeyboardMouse': supportsKeyboardMouse(context),
      'needsTVNavigation': needsTVNavigation(context),
    };
  }
}