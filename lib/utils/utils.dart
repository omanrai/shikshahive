import 'dart:developer';
import 'dart:isolate';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/const.dart';
import '../config/my_safari_chrome.dart';

class Utils {

  static Future<NavigationActionPolicy> launchUrlToExternalApplication(
      String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
    return NavigationActionPolicy.CANCEL;
  }

  static String parseXSRFTokenFromCookie(String cookieString) {
    // Implement your parsing logic here
    // Example: Extract the value of the XSRF-TOKEN cookie
    // You might need to adjust this based on your actual cookie format
    final xsrfTokenMatch =
        RegExp(r'XSRF-TOKEN=([^;]+)').firstMatch(cookieString);
    return xsrfTokenMatch?.group(1) ?? '';
  }

  static launchSafariChrome(String url) {
    final MyChromeSafariBrowser browser = MyChromeSafariBrowser();
    browser.open(
      url: WebUri.uri(Uri.parse(url)),
      options: ChromeSafariBrowserClassOptions(
          android: AndroidChromeCustomTabsOptions(
        toolbarBackgroundColor: PRIMATY_COLOR,
        isSingleInstance: false,
        showTitle: true,
        shareState: CustomTabsShareState.SHARE_STATE_ON,
        instantAppsEnabled: true,
      )),
    );
  }

  static bool checkIfIsImageLink(String url){
      RegExp imageExtensionRegex = RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp)$', caseSensitive: false);
      return imageExtensionRegex.hasMatch(url);
  }

}
