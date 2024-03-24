import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shikshahive/const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'my_safari_chrome.dart';

class Utils {
  static Future<NavigationDecision> launchUrlToExternalApplication(
      String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri);
    return NavigationDecision.navigate;
    if (url.startsWith('mailto:') || url.startsWith('googlegmail:')) {
      if (await canLaunchUrl(uri)) {
        return NavigationDecision.prevent;
      } else {
        // Handle the case when the URL cannot be launched
        return NavigationDecision.navigate;
      }
    } else if (url.startsWith('https://www.facebook.com/')) {
      // Handle Facebook URL
      if (await canLaunchUrl(Uri.parse(url))) {
        // Use the appropriate Facebook profile ID or page ID
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication,
        );
        return NavigationDecision.prevent;
      } else {
        // If the Facebook app is not installed, open in browser
        return NavigationDecision.navigate;
      }
    } else if (url.startsWith('https://www.linkedin.com/')) {
      // Handle LinkedIn URL
      if (await canLaunchUrl(uri)) {
        // Use the appropriate LinkedIn profile username or ID
        await launchUrl(uri);
        return NavigationDecision.prevent;
      } else {
        // If the LinkedIn app is not installed, open in browser
        return NavigationDecision.navigate;
      }
    } else {
      return NavigationDecision.navigate;
    }
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
      url: Uri.parse(url),
      options: ChromeSafariBrowserClassOptions(
       android: AndroidChromeCustomTabsOptions(
        toolbarBackgroundColor: PRIMATY_COLOR,
        isSingleInstance: true,
        showTitle: true,
        shareState: CustomTabsShareState.SHARE_STATE_ON,
        instantAppsEnabled: true,
       )  
      ),
    );
  }
}
