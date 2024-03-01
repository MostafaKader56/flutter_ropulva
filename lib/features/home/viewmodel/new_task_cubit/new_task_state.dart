part of 'new_task_cubit.dart';

@immutable
sealed class NewTaskState {}

final class NewTaskInitial extends NewTaskState {}


final class NewTaskLoading extends NewTaskState {}
final class NewTaskSuccess extends NewTaskState {
  final TaskModel taskModel;

  NewTaskSuccess({required this.taskModel});
}
final class NewTaskFailure extends NewTaskState {
  final String? message;

  NewTaskFailure({this.message});
}

