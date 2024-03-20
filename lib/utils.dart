import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Utils{
  static Future<NavigationDecision> launchUrlToExternalApplication(String url)async{
    final uri = Uri.parse(url);
     if (url.startsWith('mailto:') || url.startsWith('googlegmail:')) {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
                return NavigationDecision.prevent;
              } else {
                // Handle the case when the URL cannot be launched
                return NavigationDecision.navigate;
              }
            } else if (url.startsWith('https://www.facebook.com/')) {
              // Handle Facebook URL
              if (await canLaunchUrl(Uri.parse(url))) {
                // Use the appropriate Facebook profile ID or page ID
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalNonBrowserApplication,);
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
  }
