import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/widgets/my_snackbar.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});

class AuthProvider extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.signedOut;
  AuthStatus get authStatus => _authStatus;

  final authInstance = FirebaseAuth.instance;

  void checkStatus() {
    _authStatus = authInstance.currentUser != null
        ? AuthStatus.signedIn
        : AuthStatus.signedOut;
  }

  Future<void> loginInWithEmail(
      {required String email, required String password}) async {
    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      await authInstance.signInWithEmailAndPassword(
          email: email, password: password);

      _authStatus = AuthStatus.signedIn;
    } on FirebaseAuthException catch (e) {
      _authStatus = AuthStatus.signedOut;

      if (e.code == 'invalid-email' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        showSnackBar(message: 'Email or Password is invalid');
      } else if (e.code == 'user-not-found') {
        showSnackBar(message: 'User not found, please register');
      } else {
        showSnackBar(message: e.code);
      }
    }

    notifyListeners();
  }

  Future<void> registerWithEmail(
      {required String email, required String password}) async {
    _authStatus = AuthStatus.loading;
    notifyListeners();

    try {
      await authInstance.createUserWithEmailAndPassword(
          email: email, password: password);

      _authStatus = AuthStatus.signedIn;
    } on FirebaseAuthException catch (e) {
      _authStatus = AuthStatus.signedOut;

      if (e.code == 'invalid-email') {
        showSnackBar(message: 'Email or Password is invalid');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(message: 'Email already exists, please login');
      } else if (e.code == 'weak-password') {
        showSnackBar(message: 'Entered password is not strong enough');
      }
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await authInstance.signOut();

    _authStatus = AuthStatus.signedOut;
    notifyListeners();
  }
}

enum AuthStatus { signedOut, signedIn, loading }
