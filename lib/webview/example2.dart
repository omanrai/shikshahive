import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebExampleTwo extends StatefulWidget {
  final String url;
  WebExampleTwo({Key? key, required this.url}) : super(key: key);

  @override
  _WebExampleTwoState createState() => _WebExampleTwoState();
}

class _WebExampleTwoState extends State<WebExampleTwo> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? _webViewController;
  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();
  double progress = 0;
  String url = '';

  // Future<Directory?>? _externalDocumentsDirectory =
  //     getExternalStorageDirectory();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      // cacheEnabled: true,
      // transparentBackground: true,
      javaScriptEnabled: true,
      useShouldOverrideUrlLoading: true,
      useOnDownloadStart: true,
      allowFileAccessFromFileURLs: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      initialScale: 100,
      allowFileAccess: true,
      useShouldInterceptRequest: true,
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
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
            )) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tech hanger"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => _webViewController?.reload(),
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () => _webViewController?.reload(),
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(
                        url: Uri.parse('https://shikshahive.com/'),
                        headers: {},
                      ),
                      initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onDownloadStartRequest: (controller, url) async {
                        // downloading a file in a webview application
                        print("onDownloadStart $url");
                        await FlutterDownloader.enqueue(
                          url: url.toString(), // url to download
                          savedDir: (await getExternalStorageDirectory())!.path,
                          // the directory to store the download
                          fileName: 'downloads',
                          headers: {},
                          showNotification: true,
                          openFileFromNotification: true,
                        );
                      },
                      onWebViewCreated: (controller) {
                        _webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = url;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[800]!),
                          )
                        : const Center(),
                  ],
                ),
              ),
              ButtonBar(
                buttonAlignedDropdown: true,
                buttonPadding: const EdgeInsets.all(2),
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _webViewController?.goBack();
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      _webViewController?.goForward();
                    },
                  ),
                  ElevatedButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () {
                      _webViewController?.reload();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
