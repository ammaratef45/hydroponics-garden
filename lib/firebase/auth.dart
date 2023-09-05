import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:hydroponic_garden/secrets.dart';

class Auth {
  // static instance to use this as a singleton
  static Auth? _instance;

  static const List<String> scopes = [CalendarApi.calendarScope];
  late FirebaseAuth _auth;
  User? _user;
  User? get user => _user;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
    clientId: Secrets.webClientId,
  );

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

  Future<void> signIn() async {
    if (kIsWeb) {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return;
    }
    throw UnimplementedError('currently only web is supported');
  }

  Future<AuthClient?> apiClient() {
    if (kIsWeb) {
      return _googleSignIn.authenticatedClient();
    }
    throw UnimplementedError('currently only web is supported');
  }

  Future<void> logout() {
    return _auth.signOut();
  }
}
