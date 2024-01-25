import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebExampleOne extends StatefulWidget {
  WebExampleOne({Key? key}) : super(key: key);

  @override
  _WebExampleOneState createState() => _WebExampleOneState();
}

class _WebExampleOneState extends State<WebExampleOne> {
  final _flutterwebview = FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        url: 'https://shikshahive.com',
        // appBar: AppBar(
        //   title: const Text("Shiksha hive"),
        //   centerTitle: true,
        //   elevation: 0,
        // ),
        withZoom: true,
        withLocalStorage: true,
        scrollBar: true,
        withJavascript: true,
        initialChild: const Center(child: Text('Loading...')),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('This is the bottomNavigationBar of package.'),
        ),
        // persistentFooterButtons: [
        //   const CircleAvatar(
        //     backgroundColor: Colors.purple,
        //     child: Text('btn1'),
        //   ),
        //   const CircleAvatar(
        //     backgroundColor: Colors.orange,
        //     child: Text('btn2'),
        //   ),
        //   const CircleAvatar(
        //     backgroundColor: Colors.red,
        //     child: Text('btn3'),
        //   ),
        //   CircleAvatar(
        //     backgroundColor: Colors.grey[700],
        //     child: const Text('btn4'),
        //   ),
        // ],
      ),
    );
  }

  @override
  void dispose() {
    _flutterwebview.dispose();
    super.dispose();
  }
}
