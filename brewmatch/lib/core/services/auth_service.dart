import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';

/// Service d'authentification basé sur Firebase Auth.
///
/// Fournit :
/// - Future UserCredential signIn(String email, String password)
/// - Future UserCredential signUp(String email, String password)
/// - Future void signOut()
/// - User? get currentUser
///
/// Les erreurs courantes de FirebaseAuth sont capturées et loggées de façon lisible.
class AuthService {
  final FirebaseAuth _auth;

  // Private constructor that accepts a FirebaseAuth instance (allows injection for tests)
  AuthService._(this._auth);

  // Default singleton using the real FirebaseAuth instance
  static final AuthService instance = AuthService._(FirebaseAuth.instance);

  /// Helper constructor for tests to inject a mock FirebaseAuth
  factory AuthService.forAuth(FirebaseAuth auth) => AuthService._(auth);

  /// Utilisateur actuellement connecté (ou null si aucun).
  User? get currentUser => _auth.currentUser;

  /// Connecte un utilisateur avec email/mot de passe.
  ///
  /// Lance une [FirebaseAuthException] en cas d'erreur (ex : user-not-found, wrong-password).
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      developer.log(
        'Utilisateur connecté: ${credential.user?.uid}',
        name: 'AuthService',
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      final friendly = _firebaseAuthErrorMessage(e);
      developer.log(
        'signIn failed: $friendly (code=${e.code})',
        name: 'AuthService',
        error: e,
      );
      // Rethrow to let UI/consumer decide how to present the error
      throw e;
    } catch (e, st) {
      developer.log(
        'signIn unexpected error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Crée un nouvel utilisateur avec email/mot de passe.
  ///
  /// Lance une [FirebaseAuthException] en cas d'erreur (ex : email-already-in-use, weak-password).
  Future<UserCredential> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      developer.log(
        'Utilisateur créé: ${credential.user?.uid}',
        name: 'AuthService',
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      final friendly = _firebaseAuthErrorMessage(e);
      developer.log(
        'signUp failed: $friendly (code=${e.code})',
        name: 'AuthService',
        error: e,
      );
      throw e;
    } catch (e, st) {
      developer.log(
        'signUp unexpected error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Déconnecte l'utilisateur courant.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      developer.log('Utilisateur déconnecté', name: 'AuthService');
    } on FirebaseAuthException catch (e) {
      developer.log(
        'signOut failed: ${e.message} (code=${e.code})',
        name: 'AuthService',
        error: e,
      );
      rethrow;
    } catch (e, st) {
      developer.log(
        'signOut unexpected error: $e',
        name: 'AuthService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  String _firebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet e‑mail.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'invalid-email':
        return 'Adresse e‑mail invalide.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'email-already-in-use':
        return 'Cet e‑mail est déjà utilisé par un autre compte.';
      case 'operation-not-allowed':
        return 'Opération non autorisée.';
      case 'weak-password':
        return 'Mot de passe trop faible.';
      case 'network-request-failed':
        return 'Problème réseau. Vérifiez votre connexion.';
      default:
        return e.message ?? 'Erreur d’authentification inconnue.';
    }
  }
}
