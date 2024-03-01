import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/model/task_model.dart';

import '../../../../core/utils/firestore_service.dart';
import '../../../../main.dart';
import '../../data/repo/task_repo/task_repo.dart';

part 'update_task_state.dart';

class UpdateTaskCubit extends Cubit<UpdateTaskState> {
  UpdateTaskCubit(this.taskRepo) : super(UpdateTaskInitial());

  final TaskRepo taskRepo;

  Future<void> updateTask(
      TaskModel model, Function() onDone, bool isMakeDone) async {
    emit(UpdateTaskLoading());
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      getIt.get<FirestoreService>().insertData(
            RequestModel(
              kind: Kind.update,
              taskModel: model,
              func: onDone,
            ),
          );
      emit(
        UpdateTaskFailure(
          mesage:
              'No Internet Connection\nThis process will be done when network restored',
          isMakeDone: isMakeDone,
        ),
      );
      return;
    }

    final result = await taskRepo.insert(model);
    result.fold(
      (l) {
        emit(UpdateTaskFailure(mesage: l, isMakeDone: isMakeDone));
      },
      (r) {
        onDone.call();
        emit(UpdateTaskSuccess(isMakeDone: isMakeDone));
      },
    );
  }
}
