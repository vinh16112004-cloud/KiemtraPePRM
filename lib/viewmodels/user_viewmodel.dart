import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';


final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});


class TaskNotifier extends Notifier<List<TaskModel>> {
  late final UserRepository _userRepository;

  @override
  List<TaskModel> build() {
    _userRepository = ref.watch(userRepositoryProvider);
    loadTasks();
    return [];
  }


  Future<void> loadTasks() async {
    state = await _userRepository.getUsers();
  }

  Future<void> addTask(String title, String description, {bool isCompleted = false}) async {
    final newTask = TaskModel(title: title, description: description, isCompleted: isCompleted);
    await _userRepository.addUser(newTask);
    await loadTasks();
  }


  Future<void> updateTask(TaskModel task) async {
    await _userRepository.updateUser(task);
    await loadTasks();
  }
}


final taskProvider = NotifierProvider<TaskNotifier, List<TaskModel>>(() {
  return TaskNotifier();
});