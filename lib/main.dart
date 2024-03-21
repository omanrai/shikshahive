import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shikshahive/inapp_webview.dart';

import 'homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  try {
    // set true to enable printing logs to console
    // await Permission.storage.request();
    // await Permission.mediaLibrary.request();
    // // ask for storage permission on app create
    // await Permission.camera.request();
    // await Permission.microphone.request();
  } catch (e) {
    log(e.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
        primarySwatch: const MaterialColor(0xff0A6BC7, {
          50: Color(0xff0A6BC7),
          100: Color.fromARGB(255, 10, 107, 199),
          200: Color.fromARGB(255, 10, 107, 199),
          300: Color.fromARGB(255, 10, 107, 199),
          400: Color.fromARGB(255, 10, 107, 199),
          500: Color.fromARGB(255, 10, 107, 199),
          600: Color.fromARGB(255, 10, 107, 199),
          700: Color.fromARGB(255, 10, 107, 199),
          800: Color.fromARGB(255, 10, 107, 199),
          900: Color.fromARGB(255, 10, 107, 199),
        }),
      ),
      debugShowCheckedModeBanner: false,
      home: ShikshaHiveHome(),
    );
  }
}
