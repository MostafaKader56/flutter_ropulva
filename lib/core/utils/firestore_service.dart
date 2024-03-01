import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/viewmodel/load_tasks_cubit/load_tasks_cubit.dart';
import '../model/task_model.dart';
import '../repo/shared_pref_helper.dart';
import '../../features/home/data/repo/task_repo/task_repo_impl.dart';

class FirestoreService {
  bool isWaitingForNetwork = false;
  final TaskRepoImpl _taskRepoImpl = TaskRepoImpl();
  final List<RequestModel> _requestModels = SharedPrefsHelper.getRequestList();

  StreamSubscription<ConnectivityResult>? _subscription;

  late BuildContext context;

  FirestoreService init(BuildContext context) {
    if (_requestModels.isNotEmpty) {
      startListeningForNetworkStatus();
    }
    this.context = context;
    return this;
  }

  Future<void> insertData(RequestModel requestModel) async {
    _requestModels.add(requestModel);
    SharedPrefsHelper.setRequestList(_requestModels);
    startListeningForNetworkStatus();
  }

  void startListeningForNetworkStatus() async {
    if (isWaitingForNetwork) {
      return;
    }
    int i = 0;
    isWaitingForNetwork = true;
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        List<RequestModel> copyList = List.from(_requestModels);
        for (var requestModel in copyList) {
          switch (requestModel.kind) {
            case Kind.insert:
              final result = await _taskRepoImpl.insert(requestModel.taskModel);
              result.fold(
                (l) {
                  i++;
                },
                (r) {
                  _requestModels.remove(requestModel);
                  SharedPrefsHelper.setRequestList(_requestModels);
                  if (requestModel.func == null) {
                    _itemInserted(requestModel.taskModel);
                  } else {
                    requestModel.func?.call();
                  }
                },
              );
              break;
            case Kind.update:
              final result = await _taskRepoImpl.edit(requestModel.taskModel);
              result.fold(
                (l) {
                  i++;
                },
                (r) {
                  _requestModels.remove(requestModel);
                  SharedPrefsHelper.setRequestList(_requestModels);
                  if (requestModel.func == null) {
                    _itemUpdated(requestModel.taskModel);
                  } else {
                    requestModel.func?.call();
                  }
                },
              );
              break;
            case Kind.delete:
              final result = await _taskRepoImpl.delete(requestModel.taskModel);
              result.fold(
                (l) {
                  i++;
                },
                (r) {
                  _requestModels.remove(requestModel);
                  SharedPrefsHelper.setRequestList(_requestModels);
                  if (requestModel.func == null) {
                    _itemDeleted(requestModel.taskModel);
                  } else {
                    requestModel.func?.call();
                  }
                },
              );
              break;
          }
        }
        if (_requestModels.length <= i && _requestModels.isNotEmpty) {
          _subscription?.cancel();
          isWaitingForNetwork = false;
          startListeningForNetworkStatus();
        } else if (_requestModels.isEmpty) {
          _subscription?.cancel();
          isWaitingForNetwork = false;
        }
      }
    });
  }

  LoadTasksCubit getCubit() {
    return BlocProvider.of<LoadTasksCubit>(context);
  }

  void _itemUpdated(TaskModel taskModel) {
    LoadTasksCubit cubit = getCubit();
    cubit.updateTask(taskModel);
  }

  void _itemInserted(TaskModel taskModel) {
    LoadTasksCubit cubit = getCubit();
    cubit.addNewTask(taskModel);
  }

  void _itemDeleted(TaskModel taskModel) {
    LoadTasksCubit cubit = getCubit();
    cubit.deleteTask(taskModel);
  }
}

class RequestModel {
  final Kind kind;
  final TaskModel taskModel;
  final Function()? func;

  RequestModel({
    this.func,
    required this.kind,
    required this.taskModel,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      kind: _parseKind(json['kind']),
      taskModel: TaskModel.fromJson(json['taskModel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': _encodeKind(kind),
      'taskModel': taskModel.toJson(),
    };
  }

  static Kind _parseKind(String kind) {
    switch (kind) {
      case 'insert':
        return Kind.insert;
      case 'update':
        return Kind.update;
      case 'delete':
        return Kind.delete;
      default:
        throw ArgumentError('Invalid kind value: $kind');
    }
  }

  static String _encodeKind(Kind kind) {
    switch (kind) {
      case Kind.insert:
        return 'insert';
      case Kind.update:
        return 'update';
      case Kind.delete:
        return 'delete';
    }
  }
}

enum Kind {
  insert,
  update,
  delete,
}
