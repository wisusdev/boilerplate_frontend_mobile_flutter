# Sistema de Diseño Responsive - Flutter

Sistema completo de diseño responsive para aplicaciones Flutter que funciona perfectamente en móviles, tablets, escritorio y televisores.

## 🎯 Características Principales

- ✅ **Multi-dispositivo**: Soporte para móvil, tablet, desktop, large desktop y TV
- ✅ **Navegación adaptativa**: BottomNav (móvil), NavigationRail (tablet/desktop), Sidebar (TV)
- ✅ **Layouts inteligentes**: Grids adaptativos que cambian según el dispositivo
- ✅ **Formularios responsive**: Layouts verticales (móvil) y multi-columna (desktop/TV)
- ✅ **Focus management TV**: Navegación completa con control remoto para smart TVs
- ✅ **Tipografía escalable**: Texto que se adapta automáticamente según el dispositivo
- ✅ **Widgets optimizados**: Componentes diseñados específicamente para cada tipo de pantalla

## 📱 Breakpoints del Sistema

```dart
// Breakpoints de ancho
static const int mobileBreakpoint = 576;      // < 576px
static const int tabletBreakpoint = 768;      // 576px - 767px  
static const int desktopBreakpoint = 1024;    // 768px - 1023px
static const int largeDesktopBreakpoint = 1440; // 1024px - 1439px
static const int tvBreakpoint = 1920;         // >= 1440px

// Breakpoints de altura (para TV)
static const int tvHeightBreakpoint = 1080;   // >= 1080px altura
```

## 🏗️ Arquitectura del Sistema

```
lib/
├── app/utils/
│   └── responsive_layout.dart           # Core del sistema responsive
├── resources/widgets/responsive/
│   ├── responsive_widgets.dart          # Widgets base responsive
│   ├── responsive_navigation.dart       # Navegación adaptativa
│   ├── responsive_form.dart            # Formularios responsive
│   └── tv_navigation.dart              # Soporte completo para TV
└── resources/views/layouts/
    └── responsive_app_layout.dart       # Layout principal adaptativo
```

## 🚀 Uso Básico

### 1. Detección de Dispositivo

```dart
import 'package:boilerplate_frontend_mobile_flutter/app/utils/responsive_layout.dart';

// Verificar tipo de dispositivo
if (Responsive.isMobile(context)) {
  // Diseño para móvil
}

if (Responsive.isTV(context)) {
  // Diseño especial para TV
}

// Obtener tipo específico
DeviceType device = Responsive.getDeviceType(context);
```

### 2. Widgets Responsive Básicos

#### ResponsiveBuilder
```dart
ResponsiveBuilder(
  builder: (context, deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return MobileLayout();
      case DeviceType.tablet:
        return TabletLayout();
      case DeviceType.desktop:
        return DesktopLayout();
      case DeviceType.tv:
        return TVLayout();
      default:
        return DefaultLayout();
    }
  },
)
```

#### ResponsiveGrid
```dart
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2, 
  desktopColumns: 3,
  largeDesktopColumns: 4,
  tvColumns: 5,
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    // ...más items
  ],
)
```

#### ResponsiveText
```dart
ResponsiveText(
  'Mi texto adaptativo',
  style: TextStyle(fontSize: 16), // Se escala automáticamente
  autoScale: true,
)
```

### 3. Navegación Adaptativa

```dart
ResponsiveNavigation(
  items: [
    NavigationItem(
      icon: Icons.home,
      label: 'Inicio',
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Usuarios',
    ),
  ],
  selectedIndex: currentIndex,
  onDestinationSelected: (index) => setState(() => currentIndex = index),
)
```

### 4. Formularios Responsive

```dart
ResponsiveForm(
  maxColumns: 2, // En desktop usará 2 columnas
  children: [
    ResponsiveTextField(
      labelText: 'Nombre',
      controller: nameController,
    ),
    ResponsiveTextField(
      labelText: 'Email',
      controller: emailController,
    ),
    ResponsiveButton(
      text: 'Guardar',
      onPressed: () => save(),
      fullWidth: true,
    ),
  ],
)
```

### 5. Soporte para TV

```dart
// Widget con navegación por foco para TV
TVFocusableWidget(
  autofocus: true,
  onPressed: () => handleAction(),
  child: Card(
    child: Text('Elemento enfocable en TV'),
  ),
)

// ListView optimizada para TV
TVOptimizedListView(
  children: items.map((item) => 
    TVOptimizedCard(
      child: ListTile(title: Text(item.name)),
      onPressed: () => selectItem(item),
    ),
  ).toList(),
)
```

## 📐 Sistema de Espaciado y Tamaños

### Spacing Adaptativo
```dart
// Obtener spacing según dispositivo
double spacing = Responsive.getSpacing(context);
// Móvil: 8px, Tablet: 12px, Desktop: 16px, TV: 24px

// Padding adaptativo  
EdgeInsets padding = Responsive.getPadding(context);
// Móvil: 8px, Tablet: 16px, Desktop: 24px, TV: 40px
```

### Escalado de Texto
```dart
// Factor de escala automático
double scale = Responsive.getTextScaleFactor(context);
// Móvil: 1.0x, Tablet: 1.1x, Desktop: 1.0x, TV: 1.3x

// Escalado de iconos
double iconScale = Responsive.getIconScale(context);
// Móvil: 1.0x, Tablet: 1.2x, Desktop: 1.0x, TV: 1.5x
```

## 🎮 Funcionalidades TV Específicas

### 1. Focus Management
```dart
// Política de navegación para TV
FocusTraversalGroup(
  policy: TVFocusTraversalPolicy(),
  child: YourTVInterface(),
)
```

### 2. Navegación con Control Remoto
- **Enter/Select**: Activar elemento
- **Flechas direccionales**: Navegar entre elementos
- **Back**: Retroceder
- **Menu**: Opciones contextuales

### 3. Elementos TV-Optimizados
```dart
// AppBar para TV
ResponsiveAppBar(
  title: 'Mi App TV',
  toolbarHeight: 88, // Más alto en TV
)

// Cards con focus visual
TVOptimizedCard(
  autofocus: true,
  onPressed: () => action(),
  child: content,
)
```

## 🎨 Personalización de Breakpoints

```dart
// Usando el método 'when' para valores personalizados
int columns = Responsive.when<int>(
  context,
  mobile: 1,
  tablet: 2,
  desktop: 3,
  largeDesktop: 4,
  tv: 6, // Más columnas en TV
);

Widget layout = Responsive.when<Widget>(
  context,
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
  tv: TVView(),
);
```

## 📋 Ejemplos Prácticos

### Dashboard Responsive
```dart
class ResponsiveDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveContainer(
        child: ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          tvColumns: 4,
          children: dashboardItems.map((item) =>
            ResponsiveCard(
              onTap: () => navigateToModule(item),
              child: Column(
                children: [
                  Icon(item.icon, 
                    size: Responsive.getIconScale(context) * 48,
                  ),
                  ResponsiveText(item.title),
                ],
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
```

### Lista de Usuarios Adaptativa
```dart
class UserListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _buildMobileList();
    } else if (Responsive.isTablet(context)) {
      return _buildTabletGrid();
    } else if (Responsive.isTV(context)) {
      return _buildTVList();
    } else {
      return _buildDesktopTable();
    }
  }

  Widget _buildTVList() {
    return TVOptimizedListView(
      children: users.map((user) =>
        TVOptimizedCard(
          onPressed: () => selectUser(user),
          child: ListTile(
            leading: CircleAvatar(child: Text(user.initials)),
            title: ResponsiveText(user.name),
            subtitle: ResponsiveText(user.email),
          ),
        ),
      ).toList(),
    );
  }
}
```

## 🔧 Configuración Inicial

### 1. Actualizar MaterialApp
```dart
MaterialApp(
  theme: ThemeData(
    // Configurar theme para TV
    focusColor: Colors.blue,
    highlightColor: Colors.blue.withOpacity(0.2),
  ),
  builder: (context, child) {
    return FocusTraversalGroup(
      policy: Responsive.isTV(context) 
          ? TVFocusTraversalPolicy() 
          : OrderedTraversalPolicy(),
      child: child!,
    );
  },
  home: ResponsiveAppLayout(),
)
```

### 2. Usar Layout Responsive
```dart
// Reemplazar AppLayout con ResponsiveAppLayout
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveAppLayout(), // ← Usar el layout responsive
    );
  }
}
```

## 📊 Debugging y Información

### Ver información del dispositivo actual
```dart
Map<String, dynamic> deviceInfo = Responsive.getDeviceInfo(context);
print('Dispositivo: ${deviceInfo['deviceType']}');
print('Dimensiones: ${deviceInfo['width']}x${deviceInfo['height']}');
print('Soporta teclado/mouse: ${deviceInfo['supportsKeyboardMouse']}');
```

### Widget de debug
```dart
// Mostrar información de responsive en debug
if (kDebugMode) 
  Container(
    padding: EdgeInsets.all(8),
    color: Colors.black54,
    child: Text(
      'Dispositivo: ${Responsive.getDeviceType(context)}\n'
      'Ancho: ${MediaQuery.of(context).size.width.toInt()}px',
      style: TextStyle(color: Colors.white, fontSize: 12),
    ),
  ),
```

## 🎯 Mejores Prácticas

### 1. Diseño Mobile-First
```dart
// Definir siempre el caso móvil primero
Widget buildContent() {
  return Responsive.when<Widget>(
    context,
    mobile: MobileLayout(),     // ← Caso base
    tablet: TabletLayout(),     // Mejora sobre móvil
    desktop: DesktopLayout(),   // Aprovecha espacio extra
    tv: TVLayout(),            // Optimizado para distancia
  );
}
```

### 2. Performance en TV
```dart
// Limitar animaciones complejas en TV
bool useAnimations = !Responsive.isTV(context);

AnimatedContainer(
  duration: useAnimations 
      ? Duration(milliseconds: 300)
      : Duration.zero,
  child: content,
)
```

### 3. Accesibilidad
```dart
// Siempre agregar labels semánticos en TV
TVFocusableWidget(
  semanticLabel: 'Botón para crear usuario',
  child: FloatingActionButton(
    onPressed: createUser,
    child: Icon(Icons.add),
  ),
)
```

### 4. Testing Responsive
```dart
testWidgets('Dashboard adapts to different screen sizes', (tester) async {
  // Test móvil
  await tester.binding.setSurfaceSize(Size(400, 800));
  await tester.pumpWidget(MyApp());
  expect(find.byType(BottomNavigationBar), findsOneWidget);
  
  // Test desktop
  await tester.binding.setSurfaceSize(Size(1200, 800));
  await tester.pumpWidget(MyApp());
  expect(find.byType(NavigationRail), findsOneWidget);
  
  // Test TV
  await tester.binding.setSurfaceSize(Size(1920, 1080));
  await tester.pumpWidget(MyApp());
  expect(find.byType(TVOptimizedListView), findsOneWidget);
});
```

## 🚀 Migración desde Layout Existente

### Paso 1: Reemplazar AppLayout
```dart
// Antes
class MyApp extends StatelessWidget {
  Widget build(context) => MaterialApp(home: AppLayout());
}

// Después  
class MyApp extends StatelessWidget {
  Widget build(context) => MaterialApp(home: ResponsiveAppLayout());
}
```

### Paso 2: Actualizar Widgets
```dart
// Antes
GridView.count(crossAxisCount: 2, children: items)

// Después
ResponsiveGrid(
  mobileColumns: 1,
  tabletColumns: 2, 
  desktopColumns: 3,
  children: items,
)
```

### Paso 3: Migrar Formularios
```dart
// Antes
Column(children: [TextField(), TextField(), ElevatedButton()])

// Después
ResponsiveForm(
  children: [
    ResponsiveTextField(),
    ResponsiveTextField(), 
    ResponsiveButton(),
  ],
)
```

## 📱 Soporte de Dispositivos

| Dispositivo | Ancho | Layout | Navegación | Características |
|-------------|-------|--------|------------|----------------|
| **Móvil** | < 576px | Vertical, 1 columna | BottomNav | Touch, gestos |
| **Tablet** | 576-767px | 2 columnas | NavigationRail | Touch, más espacio |
| **Desktop** | 768-1439px | 3-4 columnas | Rail extendido | Mouse, teclado |
| **Large Desktop** | 1440-1919px | 4+ columnas | Rail extendido | Pantalla grande |
| **TV** | ≥1920px o ≥1080px alto | 5+ columnas | Sidebar TV | Control remoto, foco |

El sistema está listo para usar y proporcionará una experiencia óptima en todos los dispositivos target. Cada componente se adapta automáticamente según el contexto del dispositivo.
