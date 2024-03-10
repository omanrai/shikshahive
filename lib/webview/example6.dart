import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView6 extends StatefulWidget {
  const WebView6({super.key});

  @override
  State<WebView6> createState() => _WebView6State();
}

class _WebView6State extends State<WebView6> {
  late final WebViewController controller;
  var loadingPercent = 0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "SnackBar",
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      // ..setBackgroundColor(Colors.amber)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercent = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercent = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercent = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            if (url.startsWith('mailto:') || url.startsWith('googlegmail:')) {
              if (await canLaunch(url)) {
                await launch(url);
                return NavigationDecision.prevent;
              } else {
                // Handle the case when the URL cannot be launched
                return NavigationDecision.navigate;
              }
            } else if (url.startsWith('https://www.facebook.com/')) {
              // Handle Facebook URL
              if (await canLaunch("fb://profile/<profile_id>")) {
                // Use the appropriate Facebook profile ID or page ID
                await launch("fb://profile/<profile_id>");
                return NavigationDecision.prevent;
              } else {
                // If the Facebook app is not installed, open in browser
                return NavigationDecision.navigate;
              }
            } else if (url.startsWith('https://www.linkedin.com/')) {
              // Handle LinkedIn URL
              if (await canLaunch("linkedin://profile/<username>")) {
                // Use the appropriate LinkedIn profile username or ID
                await launch("linkedin://profile/<username>");
                return NavigationDecision.prevent;
              } else {
                // If the LinkedIn app is not installed, open in browser
                return NavigationDecision.navigate;
              }
            } else {
              return NavigationDecision.navigate;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://shikshahive.com'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Do you want to exit?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Shiksha hive"),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        if (await controller.canGoBack()) {
                          await controller.goBack();
                        } else {
                          messenger.showSnackBar(const SnackBar(
                              content: Text("No back history found")));
                        }
                        return;
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                  IconButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        if (await controller.canGoForward()) {
                          await controller.goForward();
                        } else {
                          messenger.showSnackBar(const SnackBar(
                              content: Text("No forward history found")));
                        }
                        return;
                      },
                      icon: const Icon(Icons.arrow_forward_ios)),
                  IconButton(
                      onPressed: () {
                        controller.reload();
                      },
                      icon: const Icon(Icons.replay)),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (loadingPercent < 100)
                LinearProgressIndicator(
                  value: loadingPercent / 100,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
