import '../models/task_model.dart';

abstract class UserRepository {
  Future<List<TaskModel>> getUsers();

  Future<TaskModel> addUser(TaskModel user);

  Future<void> updateUser(TaskModel user);
}