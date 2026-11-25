// المسار: lib/feature/student_nav_bar/provider/nav_bar.dart  (يستبدل الملف الحالي)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/authentication/provider.dart';
import '../../user/domain/entities/user_details.dart';

/// فهارس التبويبات. استخدمها بدل الأرقام:
/// NavigationProvider.instance.changeIndex(NavTab.orders);
abstract final class NavTab {
  static const int home = 0;
  static const int orders = 1;
  static const int offers = 2;
  static const int profile = 3;
  static const int count = 4;
}

class NavigationProvider extends ChangeNotifier {
  static final NavigationProvider instance = NavigationProvider._();

  NavigationProvider._();

  int _currentIndex = NavTab.home;
  bool _isBottomNavVisible = true;
  int _activeOrdersCount = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void refreshScaffoldKey() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  int get currentIndex => _currentIndex;

  bool get isBottomNavVisible => _isBottomNavVisible;

  /// عدد الطلبات النشطة (يظهر كشارة على تبويب طلباتي). يُحدَّث من شاشة الطلبات.
  int get activeOrdersCount => _activeOrdersCount;

  UserDetails? get user => AuthenticationProvider.instance.currentUser?.details;
  bool _isSideBarCollapsed = false;

  bool get isSideBarCollapsed => _isSideBarCollapsed;

  void toggleSideBar() {
    _isSideBarCollapsed = !_isSideBarCollapsed;
    notifyListeners();
  }

  void setSideBarCollapsed(bool value) {
    if (_isSideBarCollapsed != value) {
      _isSideBarCollapsed = value;
      notifyListeners();
    }
  }

  void changeIndex(int index) {
    _currentIndex = index;
    _isBottomNavVisible = true;
    notifyListeners();
  }

  void setBottomNavVisible(bool visible) {
    if (_isBottomNavVisible == visible) return;
    _isBottomNavVisible = visible;
    notifyListeners();
  }

  void setActiveOrdersCount(int count) {
    if (_activeOrdersCount == count) return;
    _activeOrdersCount = count;
    notifyListeners();
  }

  void reset() {
    _currentIndex = NavTab.home;
    _isBottomNavVisible = true;
    notifyListeners();
  }

  static NavigationProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<NavigationProvider>(context, listen: listen);
  }
}
