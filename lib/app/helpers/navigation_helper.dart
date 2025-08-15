import 'package:boilerplate_frontend_mobile_flutter/app/interfaces/local/menu_model.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/utils/menu.dart';

class AppNavigationHelper {
  // Obtener el índice global de un elemento del menú
  static int getGlobalIndex(String title) {
    final allItems = getAllMenuItems();
    return allItems.indexWhere((item) => item.title == title);
  }

  // Obtener el índice local dentro de bottom navigation
  static int getBottomNavIndex(String title) {
    final bottomNavItems = getBottomNavigationItems();
    return bottomNavItems.indexWhere((item) => item.title == title);
  }

  // Obtener el índice local dentro del drawer
  static int getDrawerIndex(String title) {
    final drawerItems = getDrawerItems();
    return drawerItems.indexWhere((item) => item.title == title);
  }

  // Verificar si un índice global corresponde a bottom navigation
  static bool isBottomNavigationIndex(int globalIndex) {
    final bottomNavCount = getBottomNavigationItems().length;
    return globalIndex >= 0 && globalIndex < bottomNavCount;
  }

  // Verificar si un índice global corresponde al drawer
  static bool isDrawerIndex(int globalIndex) {
    final bottomNavCount = getBottomNavigationItems().length;
    final allItemsCount = getAllMenuItems().length;
    return globalIndex >= bottomNavCount && globalIndex < allItemsCount;
  }

  // Convertir índice global a índice del drawer
  static int globalToDrawerIndex(int globalIndex) {
    final bottomNavCount = getBottomNavigationItems().length;
    return globalIndex - bottomNavCount;
  }

  // Convertir índice del drawer a índice global
  static int drawerToGlobalIndex(int drawerIndex) {
    final bottomNavCount = getBottomNavigationItems().length;
    return drawerIndex + bottomNavCount;
  }

  // Obtener el elemento del menú por índice global
  static MenuItem? getMenuItemByGlobalIndex(int globalIndex) {
    final allItems = getAllMenuItems();
    if (globalIndex >= 0 && globalIndex < allItems.length) {
      return allItems[globalIndex];
    }
    return null;
  }
}
