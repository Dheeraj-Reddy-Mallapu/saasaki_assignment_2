import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/constants.dart';
import 'package:saasaki_assignment_2/firebase_options.dart';
import 'package:saasaki_assignment_2/pages/home_page.dart';
import 'package:saasaki_assignment_2/pages/login_page.dart';
import 'package:saasaki_assignment_2/riverpod/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ColorScheme colorScheme({bool isDark = false}) => ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: isDark ? Brightness.dark : Brightness.light,
        );

    final auth = ref.watch(authProvider)..checkStatus();
    bool isLoggedIn = auth.authStatus == AuthStatus.signedIn;

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData.from(colorScheme: colorScheme(), useMaterial3: true),
      darkTheme: ThemeData.from(
          colorScheme: colorScheme(isDark: true), useMaterial3: true),
      home: isLoggedIn == true ? const HomePage() : const LoginPage(),
    );
  }
}
