import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:brewmatch/core/services/auth_service.dart';

void main() {
  group('AuthService (with MockFirebaseAuth)', () {
    test('signUp returns UserCredential and sets currentUser', () async {
      final mockAuth = MockFirebaseAuth();
      final service = AuthService.forAuth(mockAuth);

      final cred = await service.signUp('alice@example.com', 'password');
      expect(cred.user, isNotNull);
      expect(cred.user!.email, equals('alice@example.com'));
      expect(service.currentUser?.email, equals('alice@example.com'));
    });

    test('signIn returns UserCredential when credentials are valid', () async {
      // Create a mock auth and pre-create a user
      final mockUser = MockUser(uid: 'uid-1', email: 'bob@example.com');
      final mockAuth = MockFirebaseAuth(mockUser: mockUser);
      final service = AuthService.forAuth(mockAuth);

      // MockFirebaseAuth allows signInWithEmailAndPassword to succeed
      final cred = await service.signIn('bob@example.com', 'password');
      expect(cred.user, isNotNull);
      expect(cred.user!.email, equals('bob@example.com'));
    });

    test('signOut clears currentUser', () async {
      final mockAuth = MockFirebaseAuth();
      final service = AuthService.forAuth(mockAuth);

      // sign up & sign in first using the mock auth API
      await mockAuth.createUserWithEmailAndPassword(
        email: 'carl@example.com',
        password: 'password',
      );
      await mockAuth.signInWithEmailAndPassword(
        email: 'carl@example.com',
        password: 'password',
      );

      // ensure user is signed in
      expect(service.currentUser, isNotNull);
      await service.signOut();
      expect(service.currentUser, isNull);
    });

    // Note: MockFirebaseAuth doesn't simulate wrong-password exceptions reliably;
    // negative cases are best covered by integration tests or by using a custom
    // mock that throws FirebaseAuthException. We focus here on happy paths.
  });
}
