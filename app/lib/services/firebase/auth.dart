import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stripe_upgrade/models/user.dart' as model;
import 'package:stripe_upgrade/services/auth.dart';

class FirebaseAuthService extends AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  model.User? get user => _auth.currentUser != null
      ? model.User.fromJson(jsonDecode(jsonEncode(_auth.currentUser)))
      : null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInAnonymously();
  }
}
