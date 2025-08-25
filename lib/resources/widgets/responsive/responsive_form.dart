import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

/// Widget para formularios que se adaptan según el dispositivo
class ResponsiveForm extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double? spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool wrapInCard;
  final int? maxColumns;

  const ResponsiveForm({
    super.key,
    required this.children,
    this.padding,
    this.spacing,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.wrapInCard = true,
    this.maxColumns,
  });

  @override
  Widget build(BuildContext context) {
    final formPadding = padding ?? _getFormPadding(context);
    final formSpacing = spacing ?? _getFormSpacing(context);
    
    Widget form = _buildFormLayout(context, formSpacing);
    
    if (wrapInCard) {
      form = Card(
        elevation: _getCardElevation(context),
        margin: formPadding,
        child: Padding(
          padding: _getCardPadding(context),
          child: form,
        ),
      );
    } else {
      form = Padding(
        padding: formPadding,
        child: form,
      );
    }

    return form;
  }

  Widget _buildFormLayout(BuildContext context, double spacing) {
    // En móvil y tablet siempre usar diseño vertical
    if (Responsive.isMobileOrTablet(context)) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: _intersperse(children, SizedBox(height: spacing)),
      );
    }

    // En desktop y TV, verificar si usar columnas múltiples
    final columns = maxColumns ?? _getDefaultColumns(context);
    
    if (columns <= 1) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: _intersperse(children, SizedBox(height: spacing)),
      );
    }

    // Layout de múltiples columnas para desktop
    return _buildMultiColumnLayout(context, spacing, columns);
  }

  Widget _buildMultiColumnLayout(BuildContext context, double spacing, int columns) {
    final chunks = _chunkList(children, columns);
    
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: chunks.map((chunk) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _intersperse(
              chunk.map((widget) => Expanded(child: widget)).toList(),
              SizedBox(width: spacing),
            ),
          ),
        );
      }).toList(),
    );
  }

  int _getDefaultColumns(BuildContext context) {
    if (Responsive.isDesktop(context)) return 2;
    if (Responsive.isLargeDesktop(context)) return 2;
    if (Responsive.isTV(context)) return 3;
    return 1;
  }

  EdgeInsets _getFormPadding(BuildContext context) {
    if (Responsive.isMobile(context)) return const EdgeInsets.all(8.0);
    if (Responsive.isTablet(context)) return const EdgeInsets.all(16.0);
    if (Responsive.isDesktop(context)) return const EdgeInsets.all(24.0);
    if (Responsive.isLargeDesktop(context)) return const EdgeInsets.all(32.0);
    if (Responsive.isTV(context)) return const EdgeInsets.all(40.0);
    return const EdgeInsets.all(16.0);
  }

  EdgeInsets _getCardPadding(BuildContext context) {
    if (Responsive.isMobile(context)) return const EdgeInsets.all(16.0);
    if (Responsive.isTablet(context)) return const EdgeInsets.all(20.0);
    if (Responsive.isDesktop(context)) return const EdgeInsets.all(24.0);
    if (Responsive.isLargeDesktop(context)) return const EdgeInsets.all(28.0);
    if (Responsive.isTV(context)) return const EdgeInsets.all(32.0);
    return const EdgeInsets.all(20.0);
  }

  double _getFormSpacing(BuildContext context) {
    if (Responsive.isMobile(context)) return 12.0;
    if (Responsive.isTablet(context)) return 16.0;
    if (Responsive.isDesktop(context)) return 20.0;
    if (Responsive.isLargeDesktop(context)) return 24.0;
    if (Responsive.isTV(context)) return 28.0;
    return 16.0;
  }

  double _getCardElevation(BuildContext context) {
    if (Responsive.isMobile(context)) return 2.0;
    if (Responsive.isTablet(context)) return 4.0;
    if (Responsive.isDesktop(context)) return 6.0;
    if (Responsive.isLargeDesktop(context)) return 8.0;
    if (Responsive.isTV(context)) return 10.0;
    return 4.0;
  }

  List<T> _intersperse<T>(List<T> list, T separator) {
    if (list.isEmpty) return list;
    
    final result = <T>[];
    for (int i = 0; i < list.length; i++) {
      if (i > 0) result.add(separator);
      result.add(list[i]);
    }
    return result;
  }

  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    final chunks = <List<T>>[];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, (i + chunkSize).clamp(0, list.length)));
    }
    return chunks;
  }
}

/// Campo de texto responsive
class ResponsiveTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool enabled;

  const ResponsiveTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      style: _getTextStyle(context),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        labelStyle: _getLabelStyle(context),
        hintStyle: _getHintStyle(context),
        border: _getBorder(context),
        enabledBorder: _getBorder(context),
        focusedBorder: _getFocusedBorder(context),
        errorBorder: _getErrorBorder(context),
        contentPadding: _getContentPadding(context),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final fontSize = Responsive.when<double>(
      context,
      mobile: 16.0,
      tablet: 17.0,
      desktop: 16.0,
      largeDesktop: 17.0,
      tv: 20.0,
    );

    return TextStyle(fontSize: fontSize);
  }

  TextStyle _getLabelStyle(BuildContext context) {
    final fontSize = Responsive.when<double>(
      context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 14.0,
      largeDesktop: 15.0,
      tv: 18.0,
    );

    return TextStyle(fontSize: fontSize);
  }

  TextStyle _getHintStyle(BuildContext context) {
    final fontSize = Responsive.when<double>(
      context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 14.0,
      largeDesktop: 15.0,
      tv: 18.0,
    );

    return TextStyle(
      fontSize: fontSize,
      color: Theme.of(context).hintColor,
    );
  }

  OutlineInputBorder _getBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Theme.of(context).dividerColor,
        width: 1.0,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2.0,
      ),
    );
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    return Responsive.when<EdgeInsets>(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      tablet: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      desktop: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      largeDesktop: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      tv: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
    );
  }
}

/// Botón responsive
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool fullWidth;
  final bool loading;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.elevated,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final textStyle = _getTextStyle(context);

    Widget child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.elevated
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _getIconSize(context)),
                const SizedBox(width: 8),
              ],
              Text(text, style: textStyle),
            ],
          );

    switch (type) {
      case ButtonType.elevated:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: buttonStyle,
            child: child,
          ),
        );
      case ButtonType.outlined:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: buttonStyle,
            child: child,
          ),
        );
      case ButtonType.text:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: TextButton(
            onPressed: loading ? null : onPressed,
            style: buttonStyle,
            child: child,
          ),
        );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final padding = _getPadding(context);
    final minSize = _getMinSize(context);

    return ButtonStyle(
      padding: MaterialStateProperty.all(padding),
      minimumSize: MaterialStateProperty.all(minSize),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    final fontSize = Responsive.when<double>(
      context,
      mobile: 16.0,
      tablet: 17.0,
      desktop: 16.0,
      largeDesktop: 17.0,
      tv: 20.0,
    );

    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    return Responsive.when<EdgeInsets>(
      context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      largeDesktop: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      tv: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );
  }

  Size _getMinSize(BuildContext context) {
    return Responsive.when<Size>(
      context,
      mobile: const Size(88, 48),
      tablet: const Size(96, 52),
      desktop: const Size(104, 48),
      largeDesktop: const Size(112, 52),
      tv: const Size(120, 56),
    );
  }

  double _getIconSize(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 20.0,
      tablet: 22.0,
      desktop: 20.0,
      largeDesktop: 22.0,
      tv: 26.0,
    );
  }
}

enum ButtonType { elevated, outlined, text }
