part of 'load_tasks_cubit.dart';

@immutable
sealed class LoadTasksState {}

final class LoadTasksInitial extends LoadTasksState {}

final class LoadTasksLoading extends LoadTasksState {}
final class LoadTasksSuccess extends LoadTasksState {
  final List<TaskModel> items;

  LoadTasksSuccess({required this.items});
}
final class LoadTasksFailure extends LoadTasksState {
  final String? message;

  LoadTasksFailure({required this.message});
}
