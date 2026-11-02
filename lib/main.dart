import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'viewmodels/theme_viewmodel.dart';
import 'views/home_screen.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeColor = ref.watch(themeViewModelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVVM + SQLite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: currentThemeColor),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}