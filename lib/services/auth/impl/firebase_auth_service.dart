part of '../auth_service_factory.dart';

class _FirebaseAuthService implements AuthService {
  static const tag = '_FirebaseAuthService';
  final firebaseAuth = fauth.FirebaseAuth.instance;

  static const List<String> scopes = <String>[
    'email',
    'profile',
  ];
  final googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  @override
  Future<void> logout() async {
    await googleSignIn.signOut();
    return firebaseAuth.signOut();
  }

  Future<ServiceAction> _signInWithCredential(fauth.AuthCredential credential) async {
    try {
      await firebaseAuth.signInWithCredential(credential);
      return ServiceAction.success;
    } on fauth.FirebaseAuthException catch (e) {
      Log.e('$tag: _signInWithCredential(${credential.providerId}) error: $e');
      return ServiceAction.failure;
    }
  }

  @override
  Future<ServiceAction> signInWithApple() async {
    throw UnimplementedError("Sign in with apple not implemented yet");
  }

  @override
  Future<ServiceAction> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = fauth.GoogleAuthProvider();
        for (final scope in scopes) {
          googleProvider.addScope(scope);
        }

        try {
          await firebaseAuth.signInWithPopup(googleProvider);
          return ServiceAction.success;
        } catch (e) {
          Log.e('$tag: signInWithGoogle web error: $e');
          return ServiceAction.failure;
        }
      }

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = fauth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return _signInWithCredential(credential);
    } catch (e) {
      Log.e('$tag: signInWithGoogle() threw error: $e');
      return ServiceAction.failure;
    }
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
