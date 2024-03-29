import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:shikshahive/screens/image_viewer.dart';
import 'package:shikshahive/screens/shiksha_hive_home.dart';
import 'package:shikshahive/screens/intro.dart';
import 'package:shikshahive/screens/pdf_viewer.dart';

class MyRoutes {
  static InAppWebViewController? webViewController;

  static final route = GoRouter(
    initialLocation: "/app",
    routes: [
      GoRoute(
          path: "/app",
          name: "intro",
          builder: (context, state) => const Intro(),
          routes: [
            GoRoute(
              path: "pdf-viewer",
              name: "app.pdfViewer",
              builder: (context, state) => PdfViewer(state.extra as String),
            ),
            GoRoute(
              path: "image-viewer",
              name: "app.imageViewer",
              builder: (context, state) => ImageViewer(state.extra as String),
            ),
          ]),

      GoRoute(
        path: "/",
        builder: (context, state) {
          final initialRoute = state.extra as String?;
          return ShikshaHiveHome(initialRoute);
        },
        name: "web",
        onExit: (context) async {
          if (webViewController == null) return false;
          if (await webViewController?.canGoBack() == true) {
            webViewController?.goBack();
            return false;
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
          if (confirmed == true) SystemNavigator.pop(animated: true);

          return confirmed ?? false;
        },
      )
      // GoRoute(path: "app/pdf-viewer/:url", name: "pdfViewer", builder: (context, state) {
      //   return PdfViewer(state.pathParameters['url']);
      // },),
    ],
  );
}
