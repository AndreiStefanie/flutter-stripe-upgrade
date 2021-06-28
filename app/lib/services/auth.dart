import 'package:stripe_upgrade/models/user.dart';

abstract class AuthService {
  User? get user;
  Future<void> signIn({required String email, required String password});
}
