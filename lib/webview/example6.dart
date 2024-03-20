import 'package:flutter/material.dart';
import 'package:shikshahive/utils.dart';
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
            return Utils.launchUrlToExternalApplication(url);
          }
        ),
      )
      ..loadRequest(Uri.parse('https://shikshahive.com'));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      
      canPop: false,
     onPopInvoked: (_) async {
      if(!mounted) return;
        if (await controller.canGoBack()) {
          controller.goBack();
        
        } else {
          var confirmed = await showDialog<bool>(
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
          if(confirmed == true) Navigator.pop(context);
        }
      },
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
    );
  }
}
