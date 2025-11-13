import 'package:flutter/material.dart';

/// Defines the high-level mode the app operates in.
enum AppMode { client, admin }

/// Application state shared across navigation layers.
///
/// - Handles admin lock/unlock logic (later wired to real auth).
/// - Stores UI preferences such as the active locale.
class AppState extends ChangeNotifier {
  AppState();

  static const _adminPasscode = 'BREW2025'; // TODO: Replace with secure backend check.

  AppMode _mode = AppMode.client;
  bool _isAdminUnlocked = false;
  Locale _locale = const Locale('en');

  AppMode get mode => _mode;
  bool get isAdminUnlocked => _isAdminUnlocked;
  Locale get locale => _locale;

  void enterClientMode() {
    if (_mode == AppMode.client && !_isAdminUnlocked) {
      return;
    }
    _mode = AppMode.client;
    notifyListeners();
  }

  void lockAdmin() {
    _mode = AppMode.client;
    _isAdminUnlocked = false;
    notifyListeners();
  }

  bool unlockAdmin(String passcode) {
    final successful = passcode.trim() == _adminPasscode;
    if (successful) {
      _isAdminUnlocked = true;
      _mode = AppMode.admin;
      notifyListeners();
    }
    return successful;
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}

/// Provides [AppState] down the widget tree without an external dependency.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<AppStateScope>()
        : context.findAncestorWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in widget tree');
    return scope!.notifier!;
  }
}
