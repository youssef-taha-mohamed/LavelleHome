import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../../core/authentication/provider.dart';
import '../../../../../core/network/exception/response.dart';
import '../../../../user/domain/entities/user.dart';
import '../../../domain/entities/social_media_credentials.dart';
import '../../../domain/enums/social_media.dart';

part 'social_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSubscription;

  static const String _googleWebClientId =
      "999426049572-bnp1iggenkdrfvnt9unkhr05jo8m4vhm.apps.googleusercontent.com";

  SocialLoginCubit() : super(const SocialLoginState()) {
    _initGoogleSignIn();
  }

  Future<void> _initGoogleSignIn() async {
    try {
      await GoogleSignIn.instance.initialize(
        clientId: kIsWeb ? _googleWebClientId : null,
        serverClientId: kIsWeb ? null : _googleWebClientId,
      );

      _googleAuthSubscription =
          GoogleSignIn.instance.authenticationEvents.listen(
            _handleAuthenticationEvent,
          )..onError(_handleAuthenticationError);

      if (kIsWeb) {
        unawaited(GoogleSignIn.instance.attemptLightweightAuthentication());
      }
    } catch (e, s) {
      log('Google Sign-In initialize error: $e', stackTrace: s);
    }
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? account = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (account != null) {
      await _handleGoogleAccount(account);
    }
  }

  void _handleAuthenticationError(Object e) {
    log('Google authentication event error: $e');
    final String errorMsg = _parseError(e);
    if (errorMsg == 'cancelled') {
      emit(const SocialLoginState());
    } else {
      emit(
        state.copyWith(status: SocialLoginStatus.error, errorMessage: errorMsg),
      );
    }
  }

  factory SocialLoginCubit.of(BuildContext context) {
    return BlocProvider.of<SocialLoginCubit>(context);
  }

  @override
  Future<void> close() {
    _googleAuthSubscription?.cancel();
    return super.close();
  }

  // ─── Google Sign-In ──────────────────────────────────────────────────────
  Future<void> loginWithGoogle() async {
    if (kIsWeb) {
      return;
    }

    emit(
      state.copyWith(
        status: SocialLoginStatus.loading,
        socialMedia: SocialMediaAuthentication.google,
      ),
    );
    try {
      final account = await GoogleSignIn.instance.authenticate();
      await _handleGoogleAccount(account);
    } catch (e, s) {
      log('Google Sign-In error: $e', stackTrace: s);
      final String errorMsg = _parseError(e);
      if (errorMsg == 'cancelled') {
        emit(const SocialLoginState());
      } else {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: errorMsg,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleAccount(GoogleSignInAccount account) async {
    emit(
      state.copyWith(
        status: SocialLoginStatus.loading,
        socialMedia: SocialMediaAuthentication.google,
      ),
    );
    try {
      final GoogleSignInAuthentication auth = account.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: 'Failed to get Google token',
          ),
        );
        return;
      }

      await _authenticate(
        token: idToken,
        socialMedia: SocialMediaAuthentication.google,
        emailFromProvider: account.email,
        fullNameFromProvider: account.displayName ?? '',
      );
    } catch (e, s) {
      log('Google Web Sign-In error: $e', stackTrace: s);
      final String errorMsg = _parseError(e);
      if (errorMsg == 'cancelled') {
        emit(const SocialLoginState());
      } else {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: errorMsg,
          ),
        );
      }
    }
  }

  // ─── Apple Sign-In ───────────────────────────────────────────────────────

  Future<void> loginWithApple() async {
    emit(
      state.copyWith(
        status: SocialLoginStatus.loading,
        socialMedia: SocialMediaAuthentication.apple,
      ),
    );
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: kIsWeb
            ? WebAuthenticationOptions(
                clientId: "com.nileunited.tibastudent.login",
                redirectUri: Uri.parse(Uri.base.origin),
              )
            : null,
      );

      final String? idToken = credential.identityToken;

      if (idToken == null) {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: 'Failed to get Apple token',
          ),
        );
        return;
      }

      final String fullName = [
        credential.givenName,
        credential.familyName,
      ].where((e) => e != null && e.isNotEmpty).join(' ');

      await _authenticate(
        token: idToken,
        socialMedia: SocialMediaAuthentication.apple,
        emailFromProvider: credential.email ?? '',
        fullNameFromProvider: fullName,
      );
    } catch (e, s) {
      log('Apple Sign-In error: $e', stackTrace: s);
      final String errorMsg = _parseError(e);
      if (errorMsg == 'cancelled') {
        emit(const SocialLoginState());
      } else {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: errorMsg,
          ),
        );
      }
    }
  }

  // ─── Core Auth Logic ─────────────────────────────────────────────────────

  Future<void> _authenticate({
    required String token,
    required SocialMediaAuthentication socialMedia,
    required String emailFromProvider,
    required String fullNameFromProvider,
  }) async {
    try {
      final response = await AuthenticationProvider.instance
          .loginWithSocialMedia(
            credentials: SocialMediaCredentials(
              token: token,
              socialMedia: socialMedia,
            ),
          );

      if (response.status) {
        emit(
          state.copyWith(
            status: SocialLoginStatus.loginSuccess,
            user: response.record,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SocialLoginStatus.needsRegistration,
            token: token,
            socialMedia: socialMedia,
            emailFromProvider: emailFromProvider,
            fullNameFromProvider: fullNameFromProvider,
          ),
        );
      }
    } on UnprocessableEntityException catch (_) {
      emit(
        state.copyWith(
          status: SocialLoginStatus.needsRegistration,
          token: token,
          socialMedia: socialMedia,
          emailFromProvider: emailFromProvider,
          fullNameFromProvider: fullNameFromProvider,
        ),
      );
    } catch (e, s) {
      log('Social auth API error: $e', stackTrace: s);
      final String errorMsg = _parseError(e);
      if (errorMsg == 'cancelled') {
        emit(const SocialLoginState());
      } else {
        emit(
          state.copyWith(
            status: SocialLoginStatus.error,
            errorMessage: errorMsg,
          ),
        );
      }
    }
  }

  String _parseError(Object e) {
    if (e is SignInWithAppleAuthorizationException) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return 'cancelled';
      }
      return 'Apple Sign-In error: ${e.message}';
    }
    final errorString = e.toString().toLowerCase();
    if (errorString.contains('canceled') ||
        errorString.contains('sign_in_canceled') ||
        errorString.contains('asauthorizationerror error 1001')) {
      return 'cancelled';
    }
    if (e is DioException) return e.message ?? e.toString();
    return e.toString();
  }
}
