part of 'update_task_cubit.dart';

@immutable
sealed class UpdateTaskState {}

final class UpdateTaskInitial extends UpdateTaskState {}

final class UpdateTaskLoading extends UpdateTaskState {
}

final class UpdateTaskSuccess extends UpdateTaskState {
  final bool isMakeDone;

  UpdateTaskSuccess({required this.isMakeDone});
}

final class UpdateTaskFailure extends UpdateTaskState {
  final String? mesage;
  final bool isMakeDone;

  UpdateTaskFailure({required this.mesage,  required this.isMakeDone});
}
