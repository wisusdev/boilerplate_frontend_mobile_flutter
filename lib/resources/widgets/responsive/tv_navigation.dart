import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

/// Widget que maneja la navegación con foco para TV
class TVFocusableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final BorderRadius? borderRadius;

  const TVFocusableWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.onLongPress,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.borderRadius,
  });

  @override
  State<TVFocusableWidget> createState() => _TVFocusableWidgetState();
}

class _TVFocusableWidgetState extends State<TVFocusableWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Solo aplicar navegación por foco en TV
    if (!Responsive.isTV(context)) {
      return widget.child;
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKeyEvent,
      child: Semantics(
        label: widget.semanticLabel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            border: _isFocused
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  )
                : null,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.select ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onPressed?.call();
        return KeyEventResult.handled;
      }
      
      if (event.logicalKey == LogicalKeyboardKey.contextMenu ||
          event.logicalKey == LogicalKeyboardKey.gameButtonSelect) {
        widget.onLongPress?.call();
        return KeyEventResult.handled;
      }
    }
    
    return KeyEventResult.ignored;
  }
}

/// ListView con navegación optimizada para TV
class TVOptimizedListView extends StatefulWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final double? itemSpacing;
  final ScrollController? controller;
  final bool shrinkWrap;

  const TVOptimizedListView({
    super.key,
    required this.children,
    this.padding,
    this.itemSpacing,
    this.controller,
    this.shrinkWrap = false,
  });

  @override
  State<TVOptimizedListView> createState() => _TVOptimizedListViewState();
}

class _TVOptimizedListViewState extends State<TVOptimizedListView> {
  late ScrollController _scrollController;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = widget.itemSpacing ?? _getSpacing(context);

    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding ?? _getPadding(context),
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return TVFocusableWidget(
          autofocus: index == 0,
          onPressed: () => _onItemPressed(index),
          child: widget.children[index],
        );
      },
    );
  }

  void _onItemPressed(int index) {
    setState(() {
      _focusedIndex = index;
    });
    
    // Auto-scroll al elemento enfocado
    _scrollToItem(index);
  }

  void _scrollToItem(int index) {
    final itemHeight = 100.0; // Altura estimada del item
    final spacing = widget.itemSpacing ?? _getSpacing(context);
    final position = index * (itemHeight + spacing);
    
    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    return Responsive.when<EdgeInsets>(
      context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(16),
      desktop: const EdgeInsets.all(24),
      largeDesktop: const EdgeInsets.all(32),
      tv: const EdgeInsets.all(40),
    );
  }

  double _getSpacing(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
      largeDesktop: 20.0,
      tv: 24.0,
    );
  }
}

/// GridView optimizado para TV
class TVOptimizedGridView extends StatefulWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsets? padding;
  final double? childAspectRatio;

  const TVOptimizedGridView({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
    this.childAspectRatio,
  });

  @override
  State<TVOptimizedGridView> createState() => _TVOptimizedGridViewState();
}

class _TVOptimizedGridViewState extends State<TVOptimizedGridView> {
  int _focusedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final crossSpacing = widget.crossAxisSpacing ?? _getSpacing(context);
    final mainSpacing = widget.mainAxisSpacing ?? _getSpacing(context);

    return GridView.builder(
      padding: widget.padding ?? _getPadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: crossSpacing,
        mainAxisSpacing: mainSpacing,
        childAspectRatio: widget.childAspectRatio ?? 1.0,
      ),
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return TVFocusableWidget(
          autofocus: index == 0,
          onPressed: () => _onItemPressed(index),
          child: widget.children[index],
        );
      },
    );
  }

  void _onItemPressed(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  EdgeInsets _getPadding(BuildContext context) {
    return Responsive.when<EdgeInsets>(
      context,
      mobile: const EdgeInsets.all(8),
      tablet: const EdgeInsets.all(16),
      desktop: const EdgeInsets.all(24),
      largeDesktop: const EdgeInsets.all(32),
      tv: const EdgeInsets.all(40),
    );
  }

  double _getSpacing(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
      largeDesktop: 20.0,
      tv: 24.0,
    );
  }
}

/// Card optimizada para TV con navegación por foco
class TVOptimizedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final bool autofocus;

  const TVOptimizedCard({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation ?? _getElevation(context),
      color: color,
      margin: margin ?? EdgeInsets.zero,
      child: Padding(
        padding: padding ?? _getPadding(context),
        child: child,
      ),
    );

    if (Responsive.isTV(context)) {
      return TVFocusableWidget(
        autofocus: autofocus,
        onPressed: onPressed,
        child: card,
      );
    }

    if (onPressed != null) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: card,
      );
    }

    return card;
  }

  EdgeInsets _getPadding(BuildContext context) {
    return Responsive.when<EdgeInsets>(
      context,
      mobile: const EdgeInsets.all(12),
      tablet: const EdgeInsets.all(16),
      desktop: const EdgeInsets.all(20),
      largeDesktop: const EdgeInsets.all(24),
      tv: const EdgeInsets.all(32),
    );
  }

  double _getElevation(BuildContext context) {
    return Responsive.when<double>(
      context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
      largeDesktop: 8.0,
      tv: 12.0,
    );
  }
}

/// Helper para crear focus traversal policy optimizada para TV
class TVFocusTraversalPolicy extends OrderedTraversalPolicy {
  @override
  bool inDirection(FocusNode node, TraversalDirection direction) {
    // Personalizar la navegación direccional para TV
    switch (direction) {
      case TraversalDirection.up:
      case TraversalDirection.down:
      case TraversalDirection.left:
      case TraversalDirection.right:
        return super.inDirection(node, direction);
    }
  }

  @override
  Iterable<FocusNode> sortDescendants(
    Iterable<FocusNode> descendants,
    FocusNode currentNode,
  ) {
    // Ordenar los nodos de foco de manera óptima para TV
    final list = descendants.toList();
    
    // Ordenar por posición vertical primero, luego horizontal
    list.sort((a, b) {
      final aRect = a.rect;
      final bRect = b.rect;
      
      // Comparar por fila (top)
      final topDiff = aRect.top.compareTo(bRect.top);
      if (topDiff != 0) return topDiff;
      
      // Si están en la misma fila, comparar por columna (left)
      return aRect.left.compareTo(bRect.left);
    });
    
    return list;
  }
}
