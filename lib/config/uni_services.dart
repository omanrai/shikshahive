// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:shikhahive_webview/config/routes.dart';
// import 'package:uni_links/uni_links.dart';

// class UniServices {
//   static String _code = "";
//   static get code => _code;
//   static bool get hasCode => _code.isNotEmpty;

//   static void reset() => _code = "";

//   static void init() async {
//     try {
//       final Uri? uri = await getInitialUri();
//       uriHandler(uri);
//     } catch (e) {
//       print("init uri exception => $e");
//     }

//     uriLinkStream.listen((Uri? event) {
//       uriHandler(event);
//     });
//   }

//   static uriHandler(Uri? uri) {
//     debugPrint("URI handler: $uri");
//     if (uri == null) return;
//     final nextRoute = uri.toString().split("https://shikshahive.com/").last;
//     log("URI handler $nextRoute");
//     try {
//       if (nextRoute.startsWith("/app") ) {
//         MyRoutes.route.go(nextRoute);
//       } else {
//         MyRoutes.route.goNamed("web", extra: nextRoute);
//       }
//     } catch (e) {
//       debugPrint("URI handler $e");
//     }
//     // log("URI handler navigated to ${uri.toString()}");

//     // Map<String, String> param = uri.queryParameters;

//     // String receivedCode = param['code'] ?? '';
//   }
// }
