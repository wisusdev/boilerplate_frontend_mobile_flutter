import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/permission_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PermissionService _permissionService = PermissionService.instance;

  // Métodos helper para verificar permisos
  bool hasPermission(String permission) => _permissionService.hasPermission(permission);
  bool canView(String module) => _permissionService.hasAnyPermission(['$module:index', '$module:view', '$module:show']);
  bool canCreate(String module) => _permissionService.canCreate(module);
  bool canEdit(String module) => _permissionService.canEdit(module);
  bool canDelete(String module) => _permissionService.canDelete(module);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: _getAppBarTextSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Botón de configuraciones solo para administradores
          if (hasPermission('settings:access'))
            IconButton(
              icon: Icon(
                Icons.settings,
                size: _getIconSize(context),
              ),
              onPressed: () => Navigator.pushNamed(context, 'settings'),
            ),
        ],
        toolbarHeight: _getAppBarHeight(context),
      ),
      body: _buildResponsiveBody(context),
      floatingActionButton: _buildResponsiveFAB(context),
    );
  }

  Widget _buildResponsiveBody(BuildContext context) {
    final padding = _getPadding(context);
    final crossAxisCount = _getCrossAxisCount(context);
    final childAspectRatio = _getChildAspectRatio(context);
    
    return Padding(
      padding: padding,
      child: _buildGridOrList(context, crossAxisCount, childAspectRatio),
    );
  }

  Widget _buildGridOrList(BuildContext context, int crossAxisCount, double childAspectRatio) {
    final availableModules = _buildAvailableModules();
    
    if (Responsive.isMobile(context) && crossAxisCount == 1) {
      // En móvil con 1 columna, usar ListView para mejor scroll
      return ListView.separated(
        itemCount: availableModules.length,
        separatorBuilder: (context, index) => SizedBox(height: _getSpacing(context)),
        itemBuilder: (context, index) => availableModules[index],
      );
    } else {
      // En otros casos, usar GridView
      return GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: _getSpacing(context),
        mainAxisSpacing: _getSpacing(context),
        childAspectRatio: childAspectRatio,
        children: availableModules,
      );
    }
  }

  Widget? _buildResponsiveFAB(BuildContext context) {
    // En TV no mostrar FAB, en su lugar usar los botones en las cards
    if (Responsive.isTV(context)) return null;
    
    final fabButtons = <Widget>[];
    
    // FAB para crear usuario
    if (canCreate('users')) {
      fabButtons.add(
        FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'users_create'),
          tooltip: 'Crear Usuario',
          heroTag: "create_user",
          child: Icon(
            Icons.person_add,
            size: _getIconSize(context),
          ),
        ),
      );
    }
    
    // FAB para crear rol
    if (canCreate('roles')) {
      fabButtons.add(
        FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'roles_create'),
          tooltip: 'Crear Rol',
          heroTag: "create_role",
          child: Icon(
            Icons.add_moderator,
            size: _getIconSize(context),
          ),
        ),
      );
    }
    
    if (fabButtons.isEmpty) return null;
    
    if (fabButtons.length == 1) {
      return fabButtons.first;
    }
    
    // Múltiples FABs en columna
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: fabButtons
          .expand((fab) => [fab, SizedBox(height: _getSpacing(context))])
          .take(fabButtons.length * 2 - 1)
          .toList(),
    );
  }

  List<Widget> _buildAvailableModules() {
    List<Widget> modules = [];

    // Card de Usuarios
    if (canView('users')) {
      modules.add(_buildModuleCard(
        title: 'Usuarios',
        icon: Icons.people,
        color: Colors.blue,
        onTap: () => Navigator.pushNamed(context, 'users_index'),
        actions: _buildUserActions(),
      ));
    }

    // Card de Roles
    if (canView('roles')) {
      modules.add(_buildModuleCard(
        title: 'Roles',
        icon: Icons.admin_panel_settings,
        color: Colors.green,
        onTap: () => Navigator.pushNamed(context, 'roles_index'),
        actions: _buildRoleActions(),
      ));
    }

    // Card de Reportes (ejemplo adicional)
    if (hasPermission('reports:view')) {
      modules.add(_buildModuleCard(
        title: 'Reportes',
        icon: Icons.analytics,
        color: Colors.orange,
        onTap: () => Navigator.pushNamed(context, 'reports_index'),
        actions: _buildReportActions(),
      ));
    }

    // Card de Configuraciones
    if (hasPermission('settings:access')) {
      modules.add(_buildModuleCard(
        title: 'Configuraciones',
        icon: Icons.settings,
        color: Colors.purple,
        onTap: () => Navigator.pushNamed(context, 'settings'),
        actions: _buildSettingsActions(),
      ));
    }

    return modules;
  }

  Widget _buildModuleCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required List<Widget> actions,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildUserActions() {
    List<Widget> actions = [];
    
    if (canView('users')) {
      actions.add(_buildActionChip('Ver', Icons.visibility, Colors.blue));
    }
    
    if (canCreate('users')) {
      actions.add(_buildActionChip('Crear', Icons.add, Colors.green));
    }
    
    if (canEdit('users')) {
      actions.add(_buildActionChip('Editar', Icons.edit, Colors.orange));
    }
    
    if (canDelete('users')) {
      actions.add(_buildActionChip('Eliminar', Icons.delete, Colors.red));
    }
    
    return actions;
  }

  List<Widget> _buildRoleActions() {
    List<Widget> actions = [];
    
    if (canView('roles')) {
      actions.add(_buildActionChip('Ver', Icons.visibility, Colors.blue));
    }
    
    if (canCreate('roles')) {
      actions.add(_buildActionChip('Crear', Icons.add, Colors.green));
    }
    
    if (canEdit('roles')) {
      actions.add(_buildActionChip('Editar', Icons.edit, Colors.orange));
    }
    
    if (canDelete('roles')) {
      actions.add(_buildActionChip('Eliminar', Icons.delete, Colors.red));
    }
    
    return actions;
  }

  List<Widget> _buildReportActions() {
    List<Widget> actions = [];
    
    if (hasPermission('reports:view')) {
      actions.add(_buildActionChip('Ver', Icons.visibility, Colors.blue));
    }
    
    if (hasPermission('reports:export')) {
      actions.add(_buildActionChip('Exportar', Icons.download, Colors.green));
    }
    
    return actions;
  }

  List<Widget> _buildSettingsActions() {
    List<Widget> actions = [];
    
    if (hasPermission('settings:access')) {
      actions.add(_buildActionChip('Configurar', Icons.settings, Colors.purple));
    }
    
    return actions;
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
        ),
      ),
      avatar: Icon(
        icon,
        size: 14,
        color: color,
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  // Métodos para obtener tamaños responsive
  int _getCrossAxisCount(BuildContext context) {
    if (Responsive.isMobile(context)) return 1;
    if (Responsive.isTablet(context)) return 2;
    if (Responsive.isDesktop(context)) return 3;
    if (Responsive.isLargeDesktop(context)) return 4;
    if (Responsive.isTV(context)) return 5;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    if (Responsive.isMobile(context)) return 1.5;
    if (Responsive.isTablet(context)) return 1.3;
    if (Responsive.isDesktop(context)) return 1.2;
    if (Responsive.isLargeDesktop(context)) return 1.1;
    if (Responsive.isTV(context)) return 1.0;
    return 1.2;
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (Responsive.isMobile(context)) return const EdgeInsets.all(8.0);
    if (Responsive.isTablet(context)) return const EdgeInsets.all(16.0);
    if (Responsive.isDesktop(context)) return const EdgeInsets.all(24.0);
    if (Responsive.isLargeDesktop(context)) return const EdgeInsets.all(32.0);
    if (Responsive.isTV(context)) return const EdgeInsets.all(40.0);
    return const EdgeInsets.all(16.0);
  }

  double _getSpacing(BuildContext context) {
    if (Responsive.isMobile(context)) return 8.0;
    if (Responsive.isTablet(context)) return 12.0;
    if (Responsive.isDesktop(context)) return 16.0;
    if (Responsive.isLargeDesktop(context)) return 20.0;
    if (Responsive.isTV(context)) return 24.0;
    return 12.0;
  }

  double _getIconSize(BuildContext context) {
    if (Responsive.isMobile(context)) return 24.0;
    if (Responsive.isTablet(context)) return 28.0;
    if (Responsive.isDesktop(context)) return 32.0;
    if (Responsive.isLargeDesktop(context)) return 36.0;
    if (Responsive.isTV(context)) return 40.0;
    return 24.0;
  }

  double _getAppBarHeight(BuildContext context) {
    if (Responsive.isMobile(context)) return 56.0;
    if (Responsive.isTablet(context)) return 64.0;
    if (Responsive.isDesktop(context)) return 72.0;
    if (Responsive.isLargeDesktop(context)) return 80.0;
    if (Responsive.isTV(context)) return 88.0;
    return 56.0;
  }

  double _getAppBarTextSize(BuildContext context) {
    if (Responsive.isMobile(context)) return 20.0;
    if (Responsive.isTablet(context)) return 22.0;
    if (Responsive.isDesktop(context)) return 24.0;
    if (Responsive.isLargeDesktop(context)) return 26.0;
    if (Responsive.isTV(context)) return 28.0;
    return 20.0;
  }
}
