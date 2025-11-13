import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Defines the high-level mode the app operates in.
enum AppMode { client, admin }

/// Result returned when attempting to unlock the admin mode.
enum AdminUnlockResult { success, invalidCredentials, noAuthenticatedUser, networkError }

/// Application state shared across navigation layers.
///
/// - Handles admin lock/unlock logic backed by Firebase Auth reauthentication.
/// - Stores UI preferences such as the active locale.
class AppState extends ChangeNotifier {
  AppState({
    FirebaseAuth? firebaseAuth,
    this.adminAutoLockDelay = const Duration(minutes: 5),
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final Duration adminAutoLockDelay;

  AppMode _mode = AppMode.client;
  bool _isAdminUnlocked = false;
  Locale _locale = const Locale('en');
  Timer? _adminAutoLockTimer;

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
    _cancelAutoLockTimer();
    notifyListeners();
  }

  Future<AdminUnlockResult> unlockAdmin(String password) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      return AdminUnlockResult.noAuthenticatedUser;
    }

    try {
      final credential = EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);

      _isAdminUnlocked = true;
      _mode = AppMode.admin;
      _startAutoLockTimer();
      notifyListeners();
      return AdminUnlockResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return AdminUnlockResult.invalidCredentials;
      }
      return AdminUnlockResult.networkError;
    } catch (_) {
      return AdminUnlockResult.networkError;
    }
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  /// Keeps the admin session alive while activity is detected.
  void refreshAdminSession() {
    if (!_isAdminUnlocked) return;
    _startAutoLockTimer();
  }

  void _startAutoLockTimer() {
    _adminAutoLockTimer?.cancel();
    if (adminAutoLockDelay.isNegative || adminAutoLockDelay == Duration.zero) {
      return;
    }
    _adminAutoLockTimer = Timer(adminAutoLockDelay, lockAdmin);
  }

  void _cancelAutoLockTimer() {
    _adminAutoLockTimer?.cancel();
    _adminAutoLockTimer = null;
  }

  @override
  void dispose() {
    _cancelAutoLockTimer();
    super.dispose();
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
