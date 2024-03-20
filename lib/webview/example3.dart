import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebExampleThree extends InAppBrowser {
  @override
  // TODO: implement pullToRefreshController
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  

  @override
  Future<NavigationActionPolicy?>? shouldOverrideUrlLoading(
      NavigationAction action) async {
    var uri = action.request.url;
    if (uri != null) {
      if (uri.host.contains("facebook.com") ||
          uri.host.contains("linkedin.com") ||
          uri.host.contains("gmail.com")) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return NavigationActionPolicy.CANCEL;
        }
      }
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}
