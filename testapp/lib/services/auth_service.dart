import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  User? _user;
  User? get user => _user;

  AuthService() {
    _firebaseauth.authStateChanges().listen(authStateChangesStreamListener);
  }
  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final credential = await _firebaseauth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        _user = credential.user;
        print('SignUp Successful: ${_user?.uid}');
        return true;
      } else {
        print('SignUp Failed: User object is null');
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: Code=${e.code}, Message=${e.message}');
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use.');
      } else {
        throw Exception('Registration failed. ${e.message}');
      }
    } catch (e) {
      print('General Exception: $e');
      throw Exception('An unexpected error occurred.');
    }
    return false;
  }

  Future<bool> logOut() async {
    try {
      await _firebaseauth.signOut();
      _user = null;
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
