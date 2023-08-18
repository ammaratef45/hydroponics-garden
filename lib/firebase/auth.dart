import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth {
  // static instance to use this as a singleton
  static Auth? _instance;

  late FirebaseAuth _auth;
  User? _user;
  User? get user => _user;

  Auth._() {
    _auth = FirebaseAuth.instance;
    _auth.setPersistence(Persistence.LOCAL);
    _auth.userChanges().listen((user) {
      _user = user;
    });
  }

  static Auth instance() {
    _instance ??= Auth._();
    return _instance!;
  }

  Future<UserCredential> signIn() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    }
    throw UnimplementedError('currently only web is supported');
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
