import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/menu.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/navigation_helper.dart';
import 'package:boilerplate_frontend_mobile_flutter/core/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/responsive/responsive_navigation.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/responsive/responsive_widgets.dart';
import 'package:flutter/material.dart';

class ResponsiveAppLayout extends StatefulWidget {
  const ResponsiveAppLayout({super.key});

  @override
  State<ResponsiveAppLayout> createState() => _ResponsiveAppLayoutState();
}

class _ResponsiveAppLayoutState extends State<ResponsiveAppLayout> {
  int _selectedIndex = 0;
  final PermissionService _permissionService = PermissionService.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controla si el rail navigation está extendido
  bool get _isRailExtended {
    return Responsive.isDesktopOrLarger(context) && !_isCompactMode;
  }

  // Modo compacto para desktop cuando el espacio es limitado
  bool get _isCompactMode {
    return MediaQuery.of(context).size.width < 1200;
  }

  @override
  void initState() {
    super.initState();
    if(_permissionService.userPermissions.isEmpty){
      _permissionService.initializePermissions().then((_) {
        setState(() {
          // Refrescar estado después de cargar permisos
        });
      });
    }

    _selectedIndex = AppNavigationHelper.getGlobalIndex('home');
    if (_selectedIndex == -1) {
      _selectedIndex = 0;
    }

  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Cerrar drawer si está abierto en móvil
    if (Responsive.isMobile(context) && _scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMenuItem = AppNavigationHelper.getMenuItemByGlobalIndex(_selectedIndex);

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        print('Diseño para: $deviceType');
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(currentMenuItem);
          case DeviceType.tablet:
            return _buildTabletLayout(currentMenuItem);
          case DeviceType.desktop:
          case DeviceType.largeDesktop:
            return _buildDesktopLayout(currentMenuItem);
          case DeviceType.tv:
            return _buildTVLayout(currentMenuItem);
        }
      },
    );
  }

  Widget _buildMobileLayout(dynamic currentMenuItem) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(currentMenuItem),
      body: _buildBody(currentMenuItem),
      drawer: _buildDrawer(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTabletLayout(dynamic currentMenuItem) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(currentMenuItem),
      body: Row(
        children: [
          // Navigation Rail
          _buildNavigationRail(),
          // Main content
          Expanded(
            child: _buildBody(currentMenuItem),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(dynamic currentMenuItem) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(currentMenuItem, showMenuButton: false),
      body: Row(
        children: [
          // Navigation Rail extendido
          _buildNavigationRail(extended: _isRailExtended),
          // Divisor vertical
          const VerticalDivider(width: 1),
          // Contenido principal
          Expanded(
            child: ResponsiveContainer(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              centerChild: false,
              child: _buildBody(currentMenuItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVLayout(dynamic currentMenuItem) {
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // Navegación lateral para TV
          _buildTVNavigation(),
          // Divisor
          const VerticalDivider(width: 2),
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Header para TV
                _buildTVHeader(currentMenuItem),
                // Contenido
                Expanded(
                  child: ResponsiveContainer(
                    padding: Responsive.getPadding(context),
                    child: _buildBody(currentMenuItem),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(dynamic currentMenuItem, {bool showMenuButton = true}) {
    return AppBar(
      title: ResponsiveText(
        capitalizeText(Location.of(context)!.trans(currentMenuItem?.title ?? 'home')),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: showMenuButton
          ? IconButton(
              icon: Icon(
                Icons.menu,
                size: Responsive.getIconScale(context) * 24,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            )
          : null,
      automaticallyImplyLeading: showMenuButton,
      toolbarHeight: Responsive.when<double>(
        context,
        mobile: 56,
        tablet: 64,
        desktop: 50,
        largeDesktop: 50,
        tv: 88,
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      // Botón de configuraciones o perfil
      IconButton(
        icon: Icon(
          Icons.account_circle,
          size: Responsive.getIconScale(context) * 24,
        ),
        onPressed: () {
          // Navegar a perfil
        },
      ),
      const ResponsiveSpacer.horizontal(),
    ];
  }

  Widget _buildBody(dynamic currentMenuItem) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: currentMenuItem?.page ?? _buildDefaultContent(),
    );
  }

  Widget _buildDefaultContent() {
    return ResponsiveContainer(
      child: Center(
        child: ResponsiveText(
          'Bienvenido',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return ResponsiveDrawer(
      //header: _buildDrawerHeader(),
      items: _getDrawerItems(),
      onItemSelected: (item) {
        if (item.data != null) {
          _onNavigationItemSelected(item.data as int);
        }
      },
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      accountName: ResponsiveText(
        'Usuario',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: ResponsiveText(
        'usuario@example.com',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
          size: Responsive.getIconScale(context) * 32,
        ),
      ),
    );
  }

  List<DrawerItem> _getDrawerItems() {
    final drawerItems = [];

    // Si es un dispositivo móvil
    if (Responsive.isMobile(context)) {
      drawerItems.addAll(getDrawerItems());
    }
  // Si es un escritorio
    else {
      drawerItems.addAll(getAllMenuItems());
    }

    List<DrawerItem> items = [];

    for (int i = 0; i < drawerItems.length; i++) {
      final menuItem = drawerItems[i];
      items.add(DrawerItem(
        title: capitalizeText(Location.of(context)!.trans(menuItem.title)),
        icon: menuItem.icon,
        data: AppNavigationHelper.drawerToGlobalIndex(i),
      ));
    }

    return items;
  }

  Widget _buildBottomNavigation() {
    final bottomItems = getBottomNavigationItems();

    return BottomNavigationBar(
      currentIndex: AppNavigationHelper.isBottomNavigationIndex(_selectedIndex) ? _selectedIndex : 0,
      onTap: _onNavigationItemSelected,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      selectedLabelStyle: TextStyle(
        fontSize: Responsive.getTextScaleFactor(context) * 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: Responsive.getTextScaleFactor(context) * 12,
      ),
      items: bottomItems
          .map((menuItem) => BottomNavigationBarItem(
                icon: Icon(
                  menuItem.icon,
                  size: Responsive.getIconScale(context) * 24,
                ),
                label: capitalizeText(Location.of(context)!.trans(menuItem.title)),
              ))
          .toList(),
    );
  }

  Widget _buildNavigationRail({bool extended = false}) {
    final allItems = [...getAllMenuItems()];

    return NavigationRail(
      selectedIndex: _selectedIndex < allItems.length ? _selectedIndex : 0,
      onDestinationSelected: _onNavigationItemSelected,
      extended: extended,
      minWidth: 72,
      minExtendedWidth: 256,
      destinations: allItems.asMap().entries.map((entry) {
        final menuItem = entry.value;
        return NavigationRailDestination(
          icon: Icon(
            menuItem.icon,
            size: Responsive.getIconScale(context) * 24,
          ),
          selectedIcon: Icon(
            menuItem.icon,
            size: Responsive.getIconScale(context) * 24,
          ),
          label: ResponsiveText(
            capitalizeText(Location.of(context)!.trans(menuItem.title)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTVNavigation() {
    final allItems = [...getAllMenuItems(), ...getBottomNavigationItems()];

    return Container(
      width: 320,
      color: Theme.of(context).navigationRailTheme.backgroundColor,
      child: Column(
        children: [
          // Header para TV
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                ResponsiveText(
                  'Usuario',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const Divider(),
          // Lista de navegación
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allItems.length,
              itemBuilder: (context, index) {
                final menuItem = allItems[index];
                final isSelected = index == _selectedIndex;

                return Focus(
                  autofocus: index == 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        menuItem.icon,
                        size: 32,
                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                      ),
                      title: ResponsiveText(
                        capitalizeText(Location.of(context)!.trans(menuItem.title)),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () => _onNavigationItemSelected(index),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVHeader(dynamic currentMenuItem) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ResponsiveText(
            capitalizeText(Location.of(context)!.trans(currentMenuItem?.title ?? 'home')),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 40,
            ),
            onPressed: () {
              // Navegar a perfil
            },
          ),
        ],
      ),
    );
  }
}
