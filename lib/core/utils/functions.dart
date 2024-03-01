import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../widget/loading_dialog.dart';
import 'app_router.dart';

class Functions {
  static String getShortenedDayOfWeek(DateTime date) {
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek[date.weekday - 1];
  }

  static String getGreeting() {
    var now = DateTime.now();
    var hour = now.hour;

    if (hour >= 6 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  static void showSnackBar({required String text, int duration = 3}) {
    ScaffoldMessenger.of(AppRouter.navigatorKey.currentState!.context)
        .showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: duration),
      ),
    );
  }

  static String formatDueDate(DateTime localDateTime) {
    // Format the date string
    String formattedDate = "${getShortenedDayOfWeek(localDateTime)}. "
        "${localDateTime.day}/${localDateTime.month}/${localDateTime.year}";

    return "Due Date: $formattedDate";
  }

  static void showLoadingDialog({bool dismissible = false}) {
    showDialog(
      context: AppRouter.navigatorKey.currentContext!,
      barrierDismissible: dismissible,
      builder: (BuildContext context) {
        return PopScope(
          canPop: dismissible,
          child: const LoadingDialog(),
        );
      },
    );
  }

  static void showBottomSheet(Widget widget) {
    showModalBottomSheet(
      context: AppRouter.navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(child: widget);
      },
    );
  }

  static String generateCustomId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
