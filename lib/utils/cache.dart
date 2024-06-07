import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheUtils {
  static var _sharedPreferences = SharedPreferences.getInstance();

  static void cacheDomForOffileBrowsing(Map<String, dynamic> message) async {
    final url = message['url'] as String;
    final dom = message['dom'] as String;
    final sendPort = message['sendPort'] as SendPort;
    final isolateToken = message['isolateToken'] as RootIsolateToken;

    final cacheTime = DateTime.now().toString();
    final encodedString = jsonEncode({"dom": dom, "cachedTime": cacheTime});

    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateToken!);
    final sharedPreferences = await _sharedPreferences;
    await sharedPreferences.setString(url, encodedString);

    sendPort.send("dom stored in shared preference");
  }

  static void getCachedDomForOfflineCaching(
      Map<String, dynamic> message) async {
    final url = message['url'] as String;
    final sendPort = message['sendPort'] as SendPort;
    final isolateToken = message['isolateToken'] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateToken);


    final sharedPreferences = await _sharedPreferences;
    String? encodedString = sharedPreferences.getString(url);
    if (encodedString == null) {
      sendPort.send(null);
      return;
    }

    var decodedJson = jsonDecode(encodedString);
    sendPort.send(decodedJson['dom']);
  }
}
