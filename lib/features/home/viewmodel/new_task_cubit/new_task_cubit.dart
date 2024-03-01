import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/model/task_model.dart';
import '../../../../core/utils/firestore_service.dart';
import '../../../../main.dart';

import '../../data/repo/task_repo/task_repo.dart';

part 'new_task_state.dart';

class NewTaskCubit extends Cubit<NewTaskState> {
  NewTaskCubit(this.taskRepo) : super(NewTaskInitial());

  final TaskRepo taskRepo;

  Future<void> addNewTask(TaskModel model, Function() onDone) async {
    try {
      emit(NewTaskLoading());
      final connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.none) {
        getIt.get<FirestoreService>().insertData(
              RequestModel(
                kind: Kind.insert,
                taskModel: model,
                func: onDone,
              ),
            );
        emit(NewTaskFailure(message: 'No Internet Connection\nThis process will be done when network restored'));
        return;
      }

      final result = await taskRepo.insert(model);
      result.fold(
        (l) {
          emit(NewTaskFailure(message: l));
        },
        (r) {
          onDone.call();
          emit(NewTaskSuccess(taskModel: model));
        },
      );
    } catch (e) {
      emit(NewTaskFailure(message: e.toString()));
    }
  }
}
