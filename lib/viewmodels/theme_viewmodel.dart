import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeViewModel extends Notifier<Color> {
  @override
  Color build() {
    return Colors.blue;
  }

  void changeThemeColor(Color color) {
    state = color;
  }
}


final themeViewModelProvider = NotifierProvider<ThemeViewModel, Color>(() {
  return ThemeViewModel();
});