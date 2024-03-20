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
  try{

  // set true to enable printing logs to console
  await Permission.storage.request();
  await Permission.mediaLibrary.request();
  // ask for storage permission on app create
  await Permission.camera.request();
  await Permission.microphone.request();
  }catch(e){
    log(e.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue, visualDensity: VisualDensity.standard),
      debugShowCheckedModeBanner: false,
      home: ShikshaHiveHome(),
    );
  }
}
