import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shikshahive/config/const.dart';
import 'package:shikshahive/config/routes.dart';
import 'package:shikshahive/custom_button_sheet.dart';
import 'package:shikshahive/drawer.dart';
import 'package:shikshahive/screens/pdf_viewer.dart';
import 'package:shikshahive/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../error_container.dart';

class ShikshaHiveHome extends StatefulWidget {
  final String? initialRoute;
  const ShikshaHiveHome(this.initialRoute, {super.key});

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
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      domStorageEnabled: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  String title = "Shiksha Hive";

  bool canGoBack = false;
  bool hasError = false;

  int? errorCode;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? _sessionId;

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
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: canGoBack
              ? IconButton(
                  onPressed: () => webViewController?.goBack(),
                  icon: const Icon(Icons.arrow_back))
              : IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.home)),
          backgroundColor: const Color(0xFF0a6bc7),
          foregroundColor: Colors.white,
          title: title == "Web page not available"
              ? const Text("Error while connecting")
              : Text(title),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        // drawer: url == PRIMARY_DOMAIN
        //     ? DrawerComponent(
        //         scaffoldKey: scaffoldKey,
        //       )
        //     : null,
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
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(PRIMARY_DOMAIN),
                  ),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                    MyRoutes.webViewController = controller;
                    if (widget.initialRoute != null) {
                      // if user has link from deep link path
                      // controller.goTo(
                      //   historyItem: WebHistoryItem(
                      //     originalUrl: Uri.parse(
                      //         "$PRIMARY_DOMAIN${widget.initialRoute}"),
                      //   ),
                      // );
                      controller.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse(
                              "$PRIMARY_DOMAIN${widget.initialRoute}"),
                        ),
                      );
                    }
                  },
                  onLoadHttpError: (controller, url, statusCode, description) {
                    setState(() {
                      statusCode = statusCode;
                    });
                    _webViewLog(
                        "Status: $statusCode Description: $description Url: $url");
                  },
                  onLoadStart: onLoadStart,
                  onLongPressHitTestResult: onLongPressHitTestResult,
                  androidOnPermissionRequest: androidOnPermissionRequest,
                  onTitleChanged: onTitleChanged,
                  shouldOverrideUrlLoading: shouldOverrideUrlLoading,
                  onLoadStop: onLoadStop,
                  onLoadError: (controller, url, code, message) {
                    setState(() {
                      hasError = true;
                      errorCode = code;
                    });
                    _webViewLog("Status code $code");
                    pullToRefreshController.endRefreshing();
                  },

                  onProgressChanged: onProgressChanged,
                  onLoadResource: (controller, resource) {},
                  onDownloadStartRequest: (controller, downloadStartRequest) {
                    if (isDownloadUrl(downloadStartRequest.url)) {
                      launchUrl(downloadStartRequest.url);
                    }
                  },
                  onUpdateVisitedHistory: onUpdateVisitedHistory,
                  // onConsoleMessage: (controller, consoleMessage) {
                  //   print(consoleMessage);

                  // },
                ),
                if (progress < 1) CustomProgressIndicator(progress: progress),

                if (hasError)
                  ErrorContainer(webViewController: webViewController),
                // progress < 1.0
                //     ? LinearProgressIndicator(value: progress,color: PRIMATY_COLOR,)
                //     :const SizedBox.shrink(),
              ],
            ),
          ),
        ]));
  }

  void _webViewLog(Object? staus) => log("Web View=> $staus");

  void onLongPressHitTestResult(InAppWebViewController controller,
      InAppWebViewHitTestResult hitTestResult) {
    if (hitTestResult.extra == null) return;

    if (hitTestResult.extra!.startsWith("${PRIMARY_DOMAIN}assets/")) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => CustomButtonSheet(hitTestResult.extra!, controller),
    );
  }

  Future<PermissionRequestResponse?> androidOnPermissionRequest(
      controller, origin, resources) async {
    return PermissionRequestResponse(
        resources: resources, action: PermissionRequestResponseAction.GRANT);
  }

  void onTitleChanged(controller, title) {
    setState(() {
      this.title = title ?? "Shiksha Hive";
    });
  }

  final List<String> allowedExternalDomains = [
    "https://www.facebook.com",
    "https://www.linkedin.com",
    "https://neb.ntc.net.np",
  ];

  bool _shouldOpenExternally(Uri uri) {
    return allowedExternalDomains
        .any((domain) => uri.toString().startsWith(domain));
  }

  bool _isEmail(Uri uri) {
    return uri.toString().startsWith("mailto:");
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
    var uri = navigationAction.request.url!;
    if (isDownloadUrl(uri)) {
      _webViewLog("this is download url");
      context.push("/app/pdf-viewer", extra: '$uri');
      return NavigationActionPolicy.CANCEL;
    }

    if (_shouldOpenExternally(uri)) {
      await Utils.launchSafariChrome(uri.toString());
      return NavigationActionPolicy.CANCEL;
    }

    if (_isEmail(uri)) {
      await launchUrl(uri);
      return NavigationActionPolicy.CANCEL;
    }

    if (!url.startsWith(PRIMARY_DOMAIN)) {
      Utils.launchUrlToExternalApplication(url);
      return NavigationActionPolicy.CANCEL;
    }

    if (Utils.checkIfIsImageLink(uri.toString())) {
      context.pushNamed("app.imageViewer", extra: uri.toString());
      return NavigationActionPolicy.CANCEL;
    }

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

  void onLoadStart(InAppWebViewController controller, Uri? url) {
    setState(() {
      hasError = false;
      errorCode = null;
      this.url = url.toString();
      urlController.text = this.url;
    });
  }

  void onLoadStop(InAppWebViewController controller, Uri? url) async {
    pullToRefreshController.endRefreshing();
    final canGoBack = await controller.canGoBack();

    setState(() {
      this.url = url.toString();
      urlController.text = this.url;
      this.canGoBack = canGoBack;
    });
    progress = 1;
    _getSessionID(controller);
  }

// Assuming you have an initialized InAppWebViewController
  Future<void> _getSessionID(InAppWebViewController controller) async {
    final sessionID =
        await controller.evaluateJavascript(source: 'document.cookie');
    print('Session ID: $sessionID');
    final xsrfToken = Utils.parseXSRFTokenFromCookie(sessionID);
    log(xsrfToken);
  }

  Future<void> _loadSessionID() async {
    final prefs = await SharedPreferences.getInstance();
    final storedSessionID = prefs.getString('session_id');
    setState(() {
      _sessionId = storedSessionID;
    });
  }

  Future<void> _setSessionIDCookie() async {
    await webViewController?.evaluateJavascript(
      source: 'document.cookie = "session_id=$_sessionId";',
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    required this.progress,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: const Color(0xFF0a6bc7),
            value: progress,
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Please Wait",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
