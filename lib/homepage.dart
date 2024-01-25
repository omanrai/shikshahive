import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'check_internet.dart';
import 'webview/example1.dart';
import 'webview/example2.dart';
import 'webview/example3.dart';
import 'webview/example4.dart';
import 'webview/example5.dart';
import 'webview/example6.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final WebExampleThree inAppBrowser = WebExampleThree();
  final WebExampleFour inAppChrome = WebExampleFour();
  final String _url = "https://shikshahive.com/";
  int checkInt = 0;

  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(
        hideUrlBar: false, toolbarTopBackgroundColor: Colors.amber),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        cacheEnabled: true,
        transparentBackground: true,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        print('No internet connect');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No internet connection!'),
        ));
      } else {
        setState(() {
          checkInt = 1;
        });
        print('Internet connected');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Connected to the internet'),
        ));
      }
    });
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
      id: 1,
      label: 'Example 1',
      action: (title, url) {
        print(title);
        print(url);
      },
    ));
    inAppChrome.addMenuItem(ChromeSafariBrowserMenuItem(
      id: 2,
      label: 'Example 2',
      action: (title, url) {
        print(title);
        print(url);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Flutter Webview Tutorial'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WebExampleOne(),
                      ));
                },
                child: const Text(
                  'Example 1',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              MaterialButton(
                color: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WebExampleTwo(url: _url),
                      ));
                },
                child: const Text(
                  'Example 2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              MaterialButton(
                color: Colors.purple[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  inAppBrowser.openUrlRequest(
                      urlRequest: URLRequest(url: Uri.parse(_url)),
                      options: options);
                },
                child: const Text(
                  'Example 3',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              MaterialButton(
                color: Colors.pink[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  checkInt == 1
                      ? inAppChrome.open(
                          url: Uri.parse(_url),
                          options: ChromeSafariBrowserClassOptions(
                            android: AndroidChromeCustomTabsOptions(
                                addDefaultShareMenuItem: false),
                            ios: IOSSafariOptions(barCollapsingEnabled: true),
                          ),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection!'),
                          ),
                        );
                },
                child: const Text(
                  'Example 4',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              MaterialButton(
                color: Colors.yellow[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => WebExampleFive(url: _url)));
                },
                child: const Text(
                  'Example 05',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              MaterialButton(
                color: Colors.amber,
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => WebView6()));
                },
                child: const Text(
                  'Example 6',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL() async => await canLaunchUrl(Uri.parse(_url))
      ? await launchUrl(Uri.parse(_url))
      : throw 'Could not launch $_url';
}
