import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/model/task_model.dart';
import '../../data/repo/task_repo/task_repo.dart';

import '../../view/widget/sections_selection.dart';

part 'load_tasks_state.dart';

class LoadTasksCubit extends Cubit<LoadTasksState> {
  LoadTasksCubit(this.taskRepo) : super(LoadTasksInitial());

  final TaskRepo taskRepo;

  List<TaskModel>? items;
  SelectionType lastKind = SelectionType.all;

  Future<void> loadTasks(
      {bool pullToRefresh = false, required SelectionType kind}) async {
    if (state is LoadTasksSuccess && !pullToRefresh) {
      lastKind = kind;
      emit(LoadTasksSuccess(items: getSection(kind, items ?? [])));
      return;
    }
    emit(LoadTasksLoading());
    final result = await taskRepo.fetchTasks();
    result.fold(
      (l) {
        emit(LoadTasksFailure(message: l));
      },
      (r) {
        items = r;
        lastKind = kind;
        emit(LoadTasksSuccess(items: getSection(kind, items ?? [])));
      },
    );
  }

  List<TaskModel> getSection(SelectionType kind, List<TaskModel> items) {
    switch (kind) {
      case SelectionType.all:
        return items;
      case SelectionType.notDone:
        return items.where((element) => !element.isDone).toList();
      case SelectionType.done:
        return items.where((element) => element.isDone).toList();
    }
  }

  Future<void> addNewTask(TaskModel model) async {
    if (state is LoadTasksSuccess) {
      final newItems = (items ?? []);
      newItems.insert(0, model);
      loadTasks(kind: lastKind);
    }
  }

  Future<void> deleteTask(TaskModel model) async {
    if (state is LoadTasksSuccess) {
      List<TaskModel> copyList = List.from((items ?? []));
      for (var i = 0; i < copyList.length; i++) {
        if (copyList[i].id == model.id) {
          (items ?? []).removeAt(i);
          loadTasks(kind: lastKind);
          break;
        }
      }
    }
  }

  Future<void> updateTask(TaskModel model) async {
    if (state is LoadTasksSuccess) {
      for (var i = 0; i < (items ?? []).length; i++) {
        if (model.id == items![i].id) {
          items![i] = model;
          loadTasks(kind: lastKind);
          break;
        }
      }
    }
  }
}
