import 'dart:developer' as dev;
import 'package:jwt_decoder/jwt_decoder.dart';

/// Service responsible for handling JWT operations (Decoding, Expiration Check).
/// Implemented as a Singleton to maintain a single instance throughout the app.
class JwtService {
  // 1. Private Constructor
  JwtService._internal();

  // 2. The single instance
  static final JwtService _instance = JwtService._internal();

  // 3. Public factory to access the instance
  factory JwtService() => _instance;

  // Optional: Static getter for cleaner access like JwtService.instance.isExpired(...)
  static JwtService get instance => _instance;

  /// Checks if the provided [token] is expired.
  /// Returns `true` if expired or invalid, `false` if valid.
  bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) {
      _log('❌ Token is null or empty.');
      return true;
    }

    try {
      _log('🔍 Checking token expiration...');

      // 1. Decode to check structure validity
      final isExpired = JwtDecoder.isExpired(token);

      if (isExpired) {
        _log('⚠️ Token is EXPIRED.');
        _logExpirationDate(token); // Log when it expired for debugging
      } else {
        _log('✅ Token is VALID (Active).');
        _logExpirationDate(token); // Log when it will expire
      }

      return isExpired;
    } catch (e) {
      _log('❌ Error parsing token: $e');
      return true; // Treat as expired/invalid on error
    }
  }

  /// Decodes the token and returns the payload as a Map.
  Map<String, dynamic>? decodeToken(String token) {
    try {
      _log('🔓 Decoding token payload...');
      final decodedToken = JwtDecoder.decode(token);
      _log('📜 Payload: $decodedToken');
      return decodedToken;
    } catch (e) {
      _log('❌ Error decoding token: $e');
      return null;
    }
  }

  /// Checks if the provided [token] is an impersonation token.
  /// Backend injects `"imp": "true"` (or boolean true) in JWT payload during impersonation.
  bool isImpersonatedToken(String? token) {
    if (token == null || token.isEmpty) return false;
    try {
      final payload = decodeToken(token);
      if (payload == null) return false;
      final imp = payload['imp'];
      final isImp = imp == 'true' || imp == true;
      if (isImp) {
        _log('🎭 Detected Impersonation Token ("imp": $imp)');
      }
      return isImp;
    } catch (e) {
      _log('❌ Error checking impersonation claim: $e');
      return false;
    }
  }

  /// Helper to log the expiration date specifically
  void _logExpirationDate(String token) {
    try {
      final expirationDate = JwtDecoder.getExpirationDate(token);
      _log('CLOCK Expiration Date: $expirationDate');
      _log('CLOCK Current Device Time: ${DateTime.now()}');
    } catch (e) {
      _log('❌ Could not extract expiration date.');
    }
  }

  /// Internal logger helper to unify log format
  void _log(String message) {
    dev.log('[JwtService] $message');
  }
}
