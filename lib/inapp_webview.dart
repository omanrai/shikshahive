import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shikshahive/const.dart';
import 'package:shikshahive/drawer.dart';
import 'package:shikshahive/pdf_viewer.dart';
import 'package:shikshahive/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ShikshaHiveHome extends StatefulWidget {
  const ShikshaHiveHome({super.key});

  @override
  State<ShikshaHiveHome> createState() => _ShikshaHiveHomeState();
}

class _ShikshaHiveHomeState extends State<ShikshaHiveHome> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        useOnLoadResource: false,
        
      ),
      
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  String title = "Shiksha Hive";

  bool canGoBack = false;
  bool hasError = false;

  int? errorCode;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (await webViewController?.canGoBack() == true) {
          webViewController?.goBack();
          return;
        }

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
        if (confirmed == true) Navigator.pop(context);
      },
      child: Scaffold(
          appBar: AppBar(
            
            leading: canGoBack
                ? IconButton(
                    onPressed: () => webViewController?.goBack(),
                    icon: const Icon(Icons.arrow_back))
                : IconButton(
                    onPressed: () {}, icon: const Icon(Icons.density_medium)),
            backgroundColor: const Color(0xFF0a6bc7),
            foregroundColor: Colors.white,
            
            title:
                title=="Web page not available" ? const Text("Error while connecting") : Text(title),
            titleTextStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            centerTitle: true,

          ),
          drawer: url == PRIMARY_DOMAIN?DrawerComponent(scaffoldKey: scaffoldKey,):null,
          body: Column(children: <Widget>[
                      // TextField(
                      //   decoration: InputDecoration(
                      //       prefixIcon: Icon(Icons.search)
                      //   ),
                      //   controller: urlController,
                      //   keyboardType: TextInputType.url,
                      //   onSubmitted: (value) {
                      //     var url = Uri.parse(value);
                      //     if (url.scheme.isEmpty) {
                      //       url = Uri.parse("https://www.google.com/search?q=" + value);
                      //     }
                      //     webViewController?.loadUrl(
                      //         urlRequest: URLRequest(url: url));
                      //   },
                      // ),
                      Expanded(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest:
                    URLRequest(url: Uri.parse("https://shikshahive.com/")),
                initialOptions: options,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart:onLoadStart,
              onLongPressHitTestResult: (controller, hitTestResult) {
                log("Hit result: $hitTestResult");
              },
                androidOnPermissionRequest:
                    (controller, origin, resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                },
                onTitleChanged: (controller, title) {
                  setState(() {
                    this.title = title ?? "Shiksha Hive";
                  });
                },
                shouldOverrideUrlLoading: shouldOverrideUrlLoading,
                onLoadStop: onLoadStop,
                onLoadError: (controller, url, code, message) {
                  setState(() {
                    hasError = true;
                    errorCode = code;
                  });
                  pullToRefreshController.endRefreshing();
                },
                onProgressChanged: onProgressChanged,
                onLoadResource: (controller, resource) {
                  log(resource.url.toString());
                },
                onDownloadStartRequest: (controller, downloadStartRequest) {
                  if (isDownloadUrl(downloadStartRequest.url)) {
                    launchUrl(downloadStartRequest.url);
                  }
                },
                onUpdateVisitedHistory: onUpdateVisitedHistory,
                onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage);
                },
              ),
              if (progress < 1)
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF0a6bc7),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Please Wait",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
          
              if (hasError)
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          webViewController!.reload();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMATY_COLOR,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Refresh"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "error occured",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress,color: PRIMATY_COLOR,)
                  :const SizedBox.shrink(),
            ],
          ),
                      ),
                      // ButtonBar(
                      //   alignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     ElevatedButton(
                      //       child: Icon(Icons.arrow_back),
                      //       onPressed: () {
                      //         webViewController?.goBack();
                      //       },
                      //     ),
                      //     ElevatedButton(
                      //       child: Icon(Icons.arrow_forward),
                      //       onPressed: () {
                      //         webViewController?.goForward();
                      //       },
                      //     ),
                      //     ElevatedButton(
                      //       child: Icon(Icons.refresh),
                      //       onPressed: () {
                      //         webViewController?.reload();
                      //       },
                      //     ),
                      //   ],
                      // ),
                    ])),
    );
  }

  final List<String> allowedExternalDomains = [
    "https://www.facebook.com",
    "https://www.linkedin.com",
    "mailto:"
  ];

  bool _shouldOpenExternally(Uri uri) {
    return allowedExternalDomains
        .any((domain) => uri.toString().startsWith(domain));
  }

  bool _isEmail(Uri uri) {
    return uri.toFilePath().startsWith("mailto:");
  }

  bool isDownloadUrl(Uri uri) {
    final List<String> externalExtensions = [".pdf", ".docx", ".xlsx", ".pptx"];
    return externalExtensions.any((ext) => uri.toString().endsWith(ext));
  }

  // oid Function(InAppWebViewController, int)? onProgressChange
  void onProgressChanged(InAppWebViewController controller, int progress) {
    if (progress == 100) {
      pullToRefreshController.endRefreshing();
    }
    setState(() {
      this.progress = progress / 100;
    });
  }

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller,
      NavigationAction navigationAction) async {
    log("Navigation action $navigationAction");
    var uri = navigationAction.request.url!;
    log("URI: $uri");
    if (isDownloadUrl(uri)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewer(uri.toString()),
        ),
      );
      return NavigationActionPolicy.CANCEL;
    }
    log("is download url");
    if (_shouldOpenExternally(uri) || _isEmail(uri)) {
      await Utils.launchUrlToExternalApplication(url);
      return NavigationActionPolicy.CANCEL;
    }

    log("Url: $url");
    log("Primary Domain: $PRIMARY_DOMAIN");
    log("${url.startsWith(PRIMARY_DOMAIN)}");
    if (!url.startsWith(PRIMARY_DOMAIN)) {
      Utils.launchUrlToExternalApplication(url);
      return NavigationActionPolicy.CANCEL;
    }

    log("Should open vanda tala");

    return NavigationActionPolicy.ALLOW;
  }

  //void Function(InAppWebViewController, Uri?, bool?)? onUpdateVisitedHistory
  void onUpdateVisitedHistory(
      InAppWebViewController controller, Uri? uri, bool? updated) {
    setState(() {
      url = uri.toString();
      urlController.text = url;
    });
  }

  void onLoadStart (InAppWebViewController controller,Uri? url) {
                      log("Loading started ==> $url");
                      setState(() {
                        hasError = false;
                        errorCode = null;
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    }

                    void onLoadStop(controller, url) async {
                      pullToRefreshController.endRefreshing();
                      final canGoBack = await controller.canGoBack();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                        this.canGoBack = canGoBack;
                      });
                      progress = 1;
                    }
}
