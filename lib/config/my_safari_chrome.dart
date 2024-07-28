import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad(bool? isLoaded) {
    debugPrint("ChromeSafari browser initial load completed $isLoaded");
  }

  @override
  void onClosed() {
    debugPrint ("ChromeSafari browser closed");
  }
}
