import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/pages/home_page.dart';
import 'package:saasaki_assignment_2/pages/login_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ColorScheme colorScheme({bool isDark = false}) => ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: isDark ? Brightness.dark : Brightness.light,
        );

    bool isLoggedIn = false; // TODO

    return MaterialApp(
      theme: ThemeData.from(colorScheme: colorScheme(), useMaterial3: true),
      darkTheme: ThemeData.from(
          colorScheme: colorScheme(isDark: true), useMaterial3: true),
      home: isLoggedIn == true ? const HomePage() : const LoginPage(),
    );
  }
}
