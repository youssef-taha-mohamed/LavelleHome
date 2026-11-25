import 'url_cleaner_stub.dart'
    if (dart.library.html) 'url_cleaner_web.dart' as platform_cleaner;

/// Strips query parameters from the browser address bar on Web
void cleanBrowserUrl() {
  platform_cleaner.cleanUrlParameters();
}
