import '../../../models/auth/user.dart';
import '../../utils/service_action.dart';

abstract interface class AuthService {
  Future<ServiceAction> signInWithGoogle();
  Future<ServiceAction> signInWithApple();
  Future<void> logout();
  Stream<User?> userChanges();
  bool isLoggedIn();
  User currentUser();
}
