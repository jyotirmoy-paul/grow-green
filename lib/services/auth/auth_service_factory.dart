import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:firebase_core/firebase_core.dart' as fcore;
import '../log/log.dart';
import '../utils/service_action.dart';

import '../../models/auth/user.dart';
import 'interface/auth_service.dart';

part 'impl/firebase_auth_service.dart';

enum SupportedAuthService {
  firebase,
}

abstract class AuthServiceFactory {
  static AuthService build(SupportedAuthService supportedAuthService) {
    switch (supportedAuthService) {
      case SupportedAuthService.firebase:
        return _FirebaseAuthService();
    }
  }
}
