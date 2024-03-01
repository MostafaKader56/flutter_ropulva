import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/firestore_service.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../../main.dart';
import 'my_error_widget.dart';
import '../../viewmodel/delete_task_cubit/delete_task_cubit.dart';
import '../../viewmodel/load_tasks_cubit/load_tasks_cubit.dart';
import '../../viewmodel/update_task_cubit/update_task_cubit.dart';
import '../../../../core/model/task_model.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/widget/constants.dart';
import 'create_task_bottom_sheet_widget.dart';
import 'task_card.dart';
import '../../viewmodel/new_task_cubit/new_task_cubit.dart';

import 'sections_selection.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<TaskModel> items = [];

    SelectionType currentType = SelectionType.all;

    getIt.registerSingleton<FirestoreService>(FirestoreService().init(context));

    return MultiBlocListener(
      listeners: [
        BlocListener<NewTaskCubit, NewTaskState>(
          listener: (context, state) {
            if (state case NewTaskLoading()) {
              Functions.showLoadingDialog();
            } else if (state case NewTaskSuccess()) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Functions.showSnackBar(text: 'Task added successfully');
            } else if (state case NewTaskFailure()) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Functions.showSnackBar(
                text: state.message ?? 'Something went wrong.',
              );
            }
          },
        ),
        BlocListener<UpdateTaskCubit, UpdateTaskState>(
          listener: (context, state) {
            if (state case UpdateTaskLoading()) {
              Functions.showLoadingDialog();
            } else if (state case UpdateTaskSuccess()) {
              Navigator.of(context).pop();
              if (!state.isMakeDone) {
                Navigator.of(context).pop();
              }
              Functions.showSnackBar(text: 'Task updated successfully');
            } else if (state case UpdateTaskFailure()) {
              Navigator.of(context).pop();
              if (!state.isMakeDone) {
                Navigator.of(context).pop();
              }
              Functions.showSnackBar(
                text: state.mesage ?? 'Something went wrong.',
              );
            }
          },
        ),
        BlocListener<DeleteTaskCubit, DeleteTaskState>(
          listener: (context, state) {
            if (state case DeleteTaskLoading()) {
              Functions.showLoadingDialog();
            } else if (state case DeleteTaskSuccess()) {
              Navigator.of(context).pop();
              Functions.showSnackBar(text: 'Task deleted successfully');
            } else if (state case DeleteTaskFailure()) {
              Navigator.of(context).pop();
              Functions.showSnackBar(
                text: state.message ?? 'Something went wrong.',
              );
            }
          },
        ),
      ],
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text(
                      Functions.getGreeting(),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  SelectionTypeSection(
                    tasksTypeChange: (SelectionType type) {
                      currentType = type;
                      BlocProvider.of<LoadTasksCubit>(context).loadTasks(
                        kind: currentType,
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<LoadTasksCubit, LoadTasksState>(
                      builder: (context8, state) {
                        if (state is LoadTasksSuccess) {
                          items = state.items;
                          if (items.isEmpty) {
                            return const EmptyWidget();
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              BlocProvider.of<LoadTasksCubit>(context)
                                  .loadTasks(
                                kind: currentType,
                                pullToRefresh: true,
                              );
                            },
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context0, index) {
                                return TaskCard(
                                  model: items[index],
                                  onLongPress: (TaskModel model,
                                      void Function(TaskModel) onEdit) {
                                    showDialog(
                                      context: context0,
                                      builder: (BuildContext context1) {
                                        return AlertDialog(
                                          title: const Text('Alert'),
                                          content: const Text(
                                            'Do you want to delete or Edit this Task.',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Functions.showBottomSheet(
                                                  CreateTaskBottomSheet(
                                                    model: model,
                                                    isEdit: true,
                                                    onFinished: (bool isEdit,
                                                        TaskModel model) {
                                                      if (isEdit) {
                                                        BlocProvider.of<
                                                                    UpdateTaskCubit>(
                                                                context)
                                                            .updateTask(
                                                          model,
                                                          () {
                                                            BlocProvider.of<
                                                                        LoadTasksCubit>(
                                                                    context)
                                                                .updateTask(
                                                                    model);
                                                            onEdit.call(model);
                                                          },
                                                          false,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Text('Edit'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                BlocProvider.of<
                                                            DeleteTaskCubit>(
                                                        context)
                                                    .deleteTask(
                                                  model,
                                                  () {
                                                    BlocProvider.of<
                                                                LoadTasksCubit>(
                                                            context)
                                                        .deleteTask(model);
                                                  },
                                                );
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDonePressed: (
                                    TaskModel model,
                                    void Function(TaskModel) onEdit,
                                  ) {
                                    model.isDone = !model.isDone;
                                    BlocProvider.of<UpdateTaskCubit>(context)
                                        .updateTask(
                                      model,
                                      () {
                                        onEdit.call(model);
                                      },
                                      true,
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else if (state is LoadTasksLoading) {
                          return const Center(child: LoadingWidget());
                        } else if (state is LoadTasksFailure) {
                          return const MyErrorWidget();
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Functions.showBottomSheet(
                      CreateTaskBottomSheet(
                        onFinished: (bool isEdit, TaskModel model) {
                          if (!isEdit) {
                            BlocProvider.of<NewTaskCubit>(context).addNewTask(
                              model,
                              () {
                                BlocProvider.of<LoadTasksCubit>(context)
                                    .addNewTask(model);
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
