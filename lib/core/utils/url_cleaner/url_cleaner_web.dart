// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

void cleanUrlParameters() {
  try {
    final location = html.window.location;
    if (location.search != null && location.search!.isNotEmpty) {
      final cleanUrl = location.pathname ?? '/';
      html.window.history.replaceState(null, '', cleanUrl);
    }
  } catch (_) {
    // Ignore any browser security/sandbox errors
  }
}
