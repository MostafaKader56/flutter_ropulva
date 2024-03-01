import 'package:flutter/material.dart';
import '../../../core/repo/shared_pref_helper.dart';
import '../../../core/utils/app_router.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/functions.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).pushReplacement(AppRouter.kHomeView);
    });

    if (SharedPrefsHelper.getThisUserTasksCollectionId() == null) {
      SharedPrefsHelper.setThisUserTasksCollectionId(
          Functions.generateCustomId());
    }
    return Container();
  }
}
