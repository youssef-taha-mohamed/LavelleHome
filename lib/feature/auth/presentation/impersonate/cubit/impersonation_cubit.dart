import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/service/impersonation_service.dart';
import '../../../../../core/utils/url_cleaner/url_cleaner.dart';
import '../../../domain/use_cases/impersonate.dart';
import 'impersonation_state.dart';

class ImpersonationCubit extends Cubit<ImpersonationState> {
  ImpersonationCubit({required this._impersonateUseCase})
    : super(const ImpersonationInitial());

  final Impersonate _impersonateUseCase;

  Future<void> loginAsUser({required String? token}) async {
    final cleanToken = token?.trim();
    if (cleanToken == null || cleanToken.isEmpty) {
      debugPrint('⚠️ [ImpersonationCubit] Empty or null token received.');
      emit(
        const ImpersonationFailure(
          message:
              'رابط تسجيل الدخول غير صالح أو لا يحتوي على رمز التحقق (Token).',
        ),
      );
      return;
    }

    emit(const ImpersonationLoading());
    try {
      debugPrint(
        '🎭 [ImpersonationCubit] Exchanging token with backend ($cleanToken)...',
      );
      final response = await _impersonateUseCase.call(token: cleanToken);
      debugPrint(
        '🎭 [ImpersonationCubit] Backend response received! status: ${response.status}',
      );

      final result = response.record;
      final user = result.user;
      final studentId = result.studentId;

      debugPrint(
        '🎭 [ImpersonationCubit] Parsed user: ${user.details.fullName}, role: ${user.details.role} (id: ${user.details.role.id}), studentId: $studentId',
      );

      // Set target student ID if applicable
      if (studentId != null && studentId.isNotEmpty) {
        ImpersonationService.setImpersonatedStudentId(studentId);
      } else {
        ImpersonationService.clear();
      }

      // Persist user session directly into Hive & Auth streams
      await AuthenticationProvider.instance.saveImpersonatedSession(user);
      debugPrint('🎭 [ImpersonationCubit] Session persisted successfully.');

      // Clean query parameters from URL
      cleanBrowserUrl();

      debugPrint('🎭 [ImpersonationCubit] Emitting ImpersonationSuccess...');
      emit(ImpersonationSuccess(user: user, studentId: studentId));
    } catch (e, stack) {
      debugPrint('❌ [ImpersonationCubit] Impersonation failed: $e\n$stack');
      cleanBrowserUrl();
      emit(
        ImpersonationFailure(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
