import 'dart:developer';
import '../authentication/provider.dart';
import 'jwt_service.dart';

/// Global service to manage admin impersonation state.
class ImpersonationService {
  ImpersonationService._();

  static String? _impersonatedStudentId;

  /// Returns true if currently running under an impersonation session targeting a specific student
  static bool get isImpersonating => _impersonatedStudentId != null;

  /// Returns true if currently running under an impersonation session:
  /// checks both JWT token claims ("imp": true) and explicit impersonated student state.
  static bool get isCurrentSessionImpersonated {
    if (isImpersonating) return true;
    final token = AuthenticationProvider.instance.currentUser?.accessToken;
    if (token != null && token.isNotEmpty) {
      return JwtService.instance.isImpersonatedToken(token);
    }
    return false;
  }

  /// The target student ID when logged in as parent on behalf of their child
  static String? get impersonatedStudentId => _impersonatedStudentId;

  /// Set target student ID
  static void setImpersonatedStudentId(String? studentId) {
    _impersonatedStudentId = studentId;
    log('🎭 [ImpersonationService] Set target student ID: $studentId');
  }

  /// Clears the impersonation state (e.g. on logout or session reset)
  static void clear() {
    _impersonatedStudentId = null;
    log('🎭 [ImpersonationService] Cleared impersonation state');
  }
}
