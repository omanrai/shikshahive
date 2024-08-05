import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

import '../screens/image_viewer.dart';
import '../screens/intro.dart';
import '../screens/pdf_viewer.dart';
import '../screens/shiksha_hive_home.dart';
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
        onExit: (context, state) async {
          if (webViewController == null) return false;

          var progress = await webViewController?.getProgress();
          if(progress == null || progress != 100){
            return false;
          }
          
          if (await webViewController?.canGoBack() == true) {
            webViewController?.goBack();
            return false;
          }
          final confirmed = await showDialog<bool>(
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
    ],
  );
}
