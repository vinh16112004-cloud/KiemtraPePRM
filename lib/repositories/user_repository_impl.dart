import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isCompleted INTEGER
      )
    ''');

    await db.insert('tasks', {
      'title': 'Làm bài tập Flutter',
      'description': 'Hoàn thành trước thứ Sáu',
      'isCompleted': 0,
    });

    await db.insert('tasks', {
      'title': 'Ôn tập Riverpod',
      'description': 'Xem lại bài giảng MVVM',
      'isCompleted': 0,
    });

    await db.insert('tasks', {
      'title': 'Chuẩn bị bài thuyết trình',
      'description': 'Nhóm 4 - Chủ đề Firebase',
      'isCompleted': 1,
    });

    await db.insert('tasks', {
      'title': 'Viết báo cáo môn học',
      'description': 'Nộp trên LMS',
      'isCompleted': 1,
    });
  }

  @override
  Future<List<TaskModel>> getUsers() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<TaskModel> addUser(TaskModel task) async {
    final db = await database;
    final id = await db.insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  @override
  Future<void> updateUser(TaskModel task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}