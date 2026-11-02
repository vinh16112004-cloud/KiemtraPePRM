import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../viewmodels/user_viewmodel.dart';
import 'package:pe2_11sanpham/viewmodels/theme_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showUserDialog(BuildContext context, WidgetRef ref, {TaskModel? user}) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: user?.title ?? '');
    final descriptionController = TextEditingController(text: user?.description ?? '');

    bool isCompleted = user?.isCompleted ?? false;

    final isEditing = user != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isEditing ? 'Sửa thông tin Task' : 'Thêm Task mới'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Tiêu đề'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Tiêu đề không được để trống!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Mô tả'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Mô tả không được để trống!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Đã hoàn thành:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: isCompleted,
                          onChanged: (value) {
                            setStateDialog(() {
                              isCompleted = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (isEditing) {
                      final updated = user.copyWith(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        isCompleted: isCompleted,
                      );
                      ref.read(taskProvider.notifier).updateTask(updated);
                    } else {
                      ref.read(taskProvider.notifier).addTask(
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                        isCompleted: isCompleted,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? 'Lưu' : 'Thêm'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(taskProvider);
    final currentThemeColor = ref.watch(themeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        backgroundColor: currentThemeColor,
        actions: [
          PopupMenuButton<Color>(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Đổi màu AppBar',
            onSelected: (Color color) {
              ref.read(themeViewModelProvider.notifier).changeThemeColor(color);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Color>>[
              const PopupMenuItem<Color>(
                value: Colors.blue,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Xanh dương'),
                  ],
                ),
              ),
              const PopupMenuItem<Color>(
                value: Colors.green,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Xanh lá'),
                  ],
                ),
              ),
              const PopupMenuItem<Color>(
                value: Colors.purple,
                child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.purple),
                    SizedBox(width: 8),
                    Text('Tím'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: users.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu công việc'))
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(
              user.title,
              style: TextStyle(
                decoration: user.isCompleted ? TextDecoration.lineThrough : null,
                color: user.isCompleted ? Colors.grey : null,
              ),
            ),
            subtitle: Text(user.description),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showUserDialog(context, ref, user: user),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}