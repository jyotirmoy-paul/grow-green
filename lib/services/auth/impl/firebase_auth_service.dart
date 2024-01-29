part of '../auth_service_factory.dart';

class _FirebaseAuthService implements AuthService {
  static const tag = '_FirebaseAuthService';
  final firebaseAuth = fauth.FirebaseAuth.instance;

  @override
  Future<void> logout() {
    return firebaseAuth.signOut();
  }

  Future<ServiceAction> _signInWithProvider(fauth.AuthProvider authProvider) async {
    try {
      await firebaseAuth.signInWithProvider(authProvider);
      return ServiceAction.success;
    } on fcore.FirebaseException catch (e) {
      Log.e('$tag: _signInWithProvider(${authProvider.providerId}) error: $e');
      return ServiceAction.failure;
    }
  }

  @override
  Future<ServiceAction> signInWithApple() async {
    return _signInWithProvider(fauth.AppleAuthProvider());
  }

  @override
  Future<ServiceAction> signInWithGoogle() async {
    return _signInWithProvider(fauth.GoogleAuthProvider());
  }

  @override
  Stream<User?> userChanges() {
    return firebaseAuth.userChanges().map(
      (user) {
        if (user == null) return null;

        return _transformUserData(user);
      },
    );
  }

  @override
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

  @override
  User currentUser() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception("$tag: No user available. Method currentUser() should only be called after isLoggedIn() check");
    }

    return _transformUserData(currentUser);
  }

  User _transformUserData(fauth.User user) {
    return User(
      id: user.uid,
      name: user.displayName,
      displayPicture: user.photoURL,
    );
  }
}
