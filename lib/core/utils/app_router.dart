import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/data/repo/task_repo/task_repo.dart';
import '../../features/home/view/home_view.dart';
import '../../features/home/viewmodel/delete_task_cubit/delete_task_cubit.dart';
import '../../features/home/viewmodel/load_tasks_cubit/load_tasks_cubit.dart';
import '../../features/home/viewmodel/new_task_cubit/new_task_cubit.dart';
import '../../features/home/viewmodel/update_task_cubit/update_task_cubit.dart';
import '../../main.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/view/widget/sections_selection.dart';
import '../../features/splash/view/splash.dart';

abstract class AppRouter {
  static const kHomeView = '/kHomeView';

  static final navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashView(),
          );
        },
      ),
      GoRoute(
        path: kHomeView,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => NewTaskCubit(getIt.get<TaskRepo>()),
                ),
                BlocProvider(
                  create: (context) => UpdateTaskCubit(getIt.get<TaskRepo>()),
                ),
                BlocProvider(
                  create: (context) => DeleteTaskCubit(getIt.get<TaskRepo>()),
                ),
                BlocProvider(
                  create: (context) => LoadTasksCubit(getIt.get<TaskRepo>())
                    ..loadTasks(kind: SelectionType.all),
                ),
              ],
              child: const HomeView(),
            ),
          );
        },
      ),
    ],
  );
}
