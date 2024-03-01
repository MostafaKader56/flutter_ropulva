

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/firestore_service.dart';
import '../../../../main.dart';

import '../../../../core/model/task_model.dart';
import '../../data/repo/task_repo/task_repo.dart';

part 'delete_task_state.dart';

class DeleteTaskCubit extends Cubit<DeleteTaskState> {
  DeleteTaskCubit(this.taskRepo) : super(DeleteTaskInitial());

  final TaskRepo taskRepo;

  Future<void> deleteTask(TaskModel model, Function() onDone) async {
    emit(DeleteTaskLoading());
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      getIt.get<FirestoreService>().insertData(
            RequestModel(
              kind: Kind.delete,
              taskModel: model,
              func: onDone,
            ),
          );
      emit(
        DeleteTaskFailure(
          message:
              'No Internet Connection\nThis process will be done when network restored',
        ),
      );
      return;
    }

    final result = await taskRepo.insert(model);
    result.fold(
      (l) {
        emit(DeleteTaskFailure(message: l));
      },
      (r) {
        onDone.call();
        emit(DeleteTaskSuccess());
      },
    );
  }
}
