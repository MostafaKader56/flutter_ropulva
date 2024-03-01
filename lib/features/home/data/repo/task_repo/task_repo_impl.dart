import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/model/task_model.dart';
import '../../../../../core/repo/shared_pref_helper.dart';
import 'task_repo.dart';

class TaskRepoImpl extends TaskRepo {
  @override
  Future<Either<String, void>> delete(TaskModel model) async {
    try {
      await FirebaseFirestore.instance
          .doc(
            '${SharedPrefsHelper.getThisUserTasksCollectionId()!}/${model.id}',
          )
          .delete();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> edit(TaskModel model) async {
    try {
      await FirebaseFirestore.instance
          .doc(
            '${SharedPrefsHelper.getThisUserTasksCollectionId()!}/${model.id}',
          )
          .update(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> insert(TaskModel model) async {
    try {
      await FirebaseFirestore.instance
          .doc(
            '${SharedPrefsHelper.getThisUserTasksCollectionId()!}/${model.id}',
          )
          .set(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TaskModel>>> fetchTasks() async {
    try {
      QuerySnapshot res = await FirebaseFirestore.instance
          .collection(SharedPrefsHelper.getThisUserTasksCollectionId()!)
          .orderBy('dateTime')
          .get();

      List<TaskModel> items = res.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Right(items);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
