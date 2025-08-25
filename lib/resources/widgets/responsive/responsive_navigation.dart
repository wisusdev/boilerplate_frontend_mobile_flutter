import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

/// Widget de navegación que se adapta según el dispositivo
class ResponsiveNavigation extends StatefulWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool extended;

  const ResponsiveNavigation({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.extended = false,
  });

  @override
  State<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  @override
  Widget build(BuildContext context) {
    return Responsive.when<Widget>(
      context,
      mobile: _buildBottomNavigation(),
      tablet: _buildNavigationRail(),
      desktop: _buildNavigationRail(extended: true),
      largeDesktop: _buildNavigationRail(extended: true),
      tv: _buildTVNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.onDestinationSelected,
      type: BottomNavigationBarType.fixed,
      backgroundColor: widget.backgroundColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      items: widget.items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.label,
        tooltip: item.tooltip,
      )).toList(),
    );
  }

  Widget _buildNavigationRail({bool extended = false}) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
      extended: extended || widget.extended,
      leading: widget.leading,
      trailing: widget.trailing,
      backgroundColor: widget.backgroundColor,
      destinations: widget.items.map((item) => NavigationRailDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(item.selectedIcon ?? item.icon),
        label: Text(item.label),
      )).toList(),
    );
  }

  Widget _buildTVNavigation() {
    return Container(
      width: 300,
      color: widget.backgroundColor ?? Theme.of(context).navigationRailTheme.backgroundColor,
      child: Column(
        children: [
          if (widget.leading != null) widget.leading!,
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = index == widget.selectedIndex;
                
                return Focus(
                  autofocus: index == 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
                        size: 28,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () => widget.onDestinationSelected(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }
}

/// Elemento de navegación
class NavigationItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String? tooltip;

  const NavigationItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
  });
}

/// Drawer responsivo que se adapta según el dispositivo
class ResponsiveDrawer extends StatelessWidget {
  final List<DrawerItem> items;
  final Widget? header;
  final Widget? footer;
  final Function(DrawerItem)? onItemSelected;

  const ResponsiveDrawer({
    super.key,
    required this.items,
    this.header,
    this.footer,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isTV(context)) {
      return _buildTVDrawer(context);
    }
    
    return _buildStandardDrawer(context);
  }

  Widget _buildStandardDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          if (header != null) header!,
          Expanded(
            child: ListView.builder(
              padding: Responsive.getPadding(context),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                
                if (item.isDivider) {
                  return const Divider();
                }
                
                return ListTile(
                  leading: item.icon != null ? Icon(item.icon) : null,
                  title: Text(item.title),
                  subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                  onTap: () {
                    Navigator.pop(context);
                    onItemSelected?.call(item);
                  },
                  trailing: item.trailing,
                );
              },
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }

  Widget _buildTVDrawer(BuildContext context) {
    return Container(
      width: 400,
      color: Theme.of(context).drawerTheme.backgroundColor,
      child: Column(
        children: [
          if (header != null) 
            Container(
              padding: const EdgeInsets.all(24),
              child: header!,
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                
                if (item.isDivider) {
                  return const Divider(height: 32);
                }
                
                return Focus(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: item.icon != null 
                          ? Icon(item.icon, size: 32) 
                          : null,
                      title: Text(
                        item.title,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: item.subtitle != null 
                          ? Text(
                              item.subtitle!,
                              style: const TextStyle(fontSize: 16),
                            ) 
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        onItemSelected?.call(item);
                      },
                      trailing: item.trailing,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (footer != null)
            Container(
              padding: const EdgeInsets.all(24),
              child: footer!,
            ),
        ],
      ),
    );
  }
}

/// Elemento del drawer
class DrawerItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final bool isDivider;
  final dynamic data;

  const DrawerItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.isDivider = false,
    this.data,
  });

  const DrawerItem.divider()
      : title = '',
        subtitle = null,
        icon = null,
        trailing = null,
        isDivider = true,
        data = null;
}

/// AppBar responsivo
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;

  const ResponsiveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: Responsive.when<double>(
        context,
        mobile: 20,
        tablet: 22,
        desktop: 24,
        largeDesktop: 26,
        tv: 28,
      ),
      fontWeight: FontWeight.w600,
    );

    return AppBar(
      title: title != null ? Text(title!, style: textStyle) : null,
      actions: actions?.map((action) => _scaleAction(context, action)).toList(),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      toolbarHeight: Responsive.when<double>(
        context,
        mobile: 56,
        tablet: 64,
        desktop: 72,
        largeDesktop: 80,
        tv: 88,
      ),
    );
  }

  Widget _scaleAction(BuildContext context, Widget action) {
    final scale = Responsive.getIconScale(context);
    
    return Transform.scale(
      scale: scale,
      child: action,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(56.0); // Se ajustará en build()
  }
}
