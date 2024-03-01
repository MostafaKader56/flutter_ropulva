import 'package:dartz/dartz.dart';
import '../../../../../core/model/task_model.dart';

abstract class TaskRepo {
  Future<Either<String, List<TaskModel> >> fetchTasks();
  Future<Either<String, void>> insert(TaskModel model);
  Future<Either<String, void>> edit(TaskModel model);
  Future<Either<String, void>> delete(TaskModel model);
}
