import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

/// Widget builder que se adapta según el tipo de dispositivo
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? tv;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.tv,
  });

  /// Constructor con widgets específicos por dispositivo
  const ResponsiveBuilder.widgets({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.tv,
  }) : builder = _defaultBuilder;

  static Widget _defaultBuilder(BuildContext context, DeviceType deviceType) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = Responsive.getDeviceType(context);

    // Si se especificaron widgets específicos, usarlos
    if (mobile != null || tablet != null || desktop != null || largeDesktop != null || tv != null) {
      switch (deviceType) {
        case DeviceType.mobile:
          return mobile ?? _fallbackWidget(context, deviceType);
        case DeviceType.tablet:
          return tablet ?? mobile ?? _fallbackWidget(context, deviceType);
        case DeviceType.desktop:
          return desktop ?? tablet ?? mobile ?? _fallbackWidget(context, deviceType);
        case DeviceType.largeDesktop:
          return largeDesktop ?? desktop ?? tablet ?? mobile ?? _fallbackWidget(context, deviceType);
        case DeviceType.tv:
          return tv ?? largeDesktop ?? desktop ?? tablet ?? mobile ?? _fallbackWidget(context, deviceType);
      }
    }

    // Usar el builder
    return builder(context, deviceType);
  }

  Widget _fallbackWidget(BuildContext context, DeviceType deviceType) {
    return builder(context, deviceType);
  }
}

/// Contenedor que se adapta automáticamente
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? maxWidth;
  final double? maxHeight;
  final Color? backgroundColor;
  final bool centerChild;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.maxHeight,
    this.backgroundColor,
    this.centerChild = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? Responsive.getPadding(context),
      margin: margin,
      color: backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? _getMaxWidth(context),
            maxHeight: maxHeight ?? double.infinity,
          ),
          child: centerChild ? Center(child: child) : child,
        ),
      ),
    );
  }

  double _getMaxWidth(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: double.infinity,
      tablet: 768,
      desktop: 1024,
      largeDesktop: 1200,
      tv: 1400,
    );
  }
}

/// Grid responsivo que adapta el número de columnas
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? largeDesktopColumns;
  final int? tvColumns;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsets? padding;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.largeDesktopColumns,
    this.tvColumns,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.getGridColumns(
      context,
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 3,
      largeDesktop: largeDesktopColumns ?? 4,
      tv: tvColumns ?? 5,
    );

    final gridSpacing = spacing ?? Responsive.getSpacing(context);

    return Padding(
      padding: padding ?? Responsive.getPadding(context),
      child: GridView.count(
        crossAxisCount: columns,
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: runSpacing ?? gridSpacing,
        childAspectRatio: childAspectRatio ?? _getChildAspectRatio(context),
        children: children,
      ),
    );
  }

  double _getChildAspectRatio(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
      largeDesktop: 1.3,
      tv: 1.4,
    );
  }
}

/// ListView responsivo con spacing adaptativo
class ResponsiveListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double? spacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool reverse;

  const ResponsiveListView({
    super.key,
    required this.children,
    this.padding,
    this.spacing,
    this.shrinkWrap = false,
    this.physics,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final listSpacing = spacing ?? Responsive.getSpacing(context);

    return ListView.separated(
      padding: padding ?? Responsive.getPadding(context),
      shrinkWrap: shrinkWrap,
      physics: physics,
      reverse: reverse,
      itemCount: children.length,
      separatorBuilder: (context, index) => SizedBox(height: listSpacing),
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Text responsivo con escalado automático
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool autoScale;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.autoScale = true,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactor = autoScale ? Responsive.getTextScaleFactor(context) : 1.0;
    
    TextStyle finalStyle = style ?? const TextStyle();
    if (autoScale && finalStyle.fontSize != null) {
      finalStyle = finalStyle.copyWith(
        fontSize: finalStyle.fontSize! * scaleFactor,
      );
    }

    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor: autoScale ? scaleFactor : 1.0,
    );
  }
}

/// Card responsivo con padding y elevation adaptativos
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardElevation = elevation ?? _getElevation(context);
    final cardPadding = padding ?? Responsive.getPadding(context);

    Widget card = Card(
      elevation: cardElevation,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
      ),
      margin: margin ?? EdgeInsets.zero,
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        child: card,
      );
    }

    return card;
  }

  double _getElevation(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
      largeDesktop: 8.0,
      tv: 10.0,
    );
  }
}

/// Spacer responsivo
class ResponsiveSpacer extends StatelessWidget {
  final double? height;
  final double? width;

  const ResponsiveSpacer({
    super.key,
    this.height,
    this.width,
  });

  const ResponsiveSpacer.vertical({super.key, this.height}) : width = null;
  const ResponsiveSpacer.horizontal({super.key, this.width}) : height = null;

  @override
  Widget build(BuildContext context) {
    final spacing = Responsive.getSpacing(context);

    return SizedBox(
      height: height ?? spacing,
      width: width ?? spacing,
    );
  }
}
