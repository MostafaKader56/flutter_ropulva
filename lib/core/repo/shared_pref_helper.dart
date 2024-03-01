import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/firestore_service.dart';


class SharedPrefsHelper {
  static late final SharedPreferences prefs;
  static bool _isPrefInitialized = false;

  static Future<void> init() async {
    if (_isPrefInitialized) {
      return;
    }
    prefs = await SharedPreferences.getInstance().then((value) {
      _isPrefInitialized = true;
      return value;
    });
  }

  // Keys
  static const String _thisUerTasksCollectionIdKey = '_thisUerTasksCollectionIdKey';
  static const String _requestListKey = '_requestListKey';

  static Future<void> setThisUserTasksCollectionId(String thereIs) async {
    await prefs.setString(_thisUerTasksCollectionIdKey, thereIs);
  }

  static String? getThisUserTasksCollectionId() {
    return prefs.getString(_thisUerTasksCollectionIdKey);
  }

    static Future<void> setRequestList(List<RequestModel> requests) async {
    final List<String> requestJsonList = requests.map((req) => jsonEncode(req.toJson())).toList();
    await prefs.setStringList(_requestListKey, requestJsonList);
  }

  static List<RequestModel> getRequestList() {
    final List<String>? requestJsonList = prefs.getStringList(_requestListKey);
    if (requestJsonList == null || requestJsonList.isEmpty) {
      return [];
    }
    return requestJsonList.map((jsonString) => RequestModel.fromJson(jsonDecode(jsonString))).toList();
  }
}
