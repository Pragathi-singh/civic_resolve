import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth/login_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Diagnostics
    assert(Firebase.apps.isNotEmpty);
    final app = Firebase.app();
    // These prints help verify config during web runs
    // They show in the browser devtools console and debug console
    // (no sensitive data beyond project identifiers)
    // ignore: avoid_print
    print('Firebase initialized. apps=${Firebase.apps.length}');
    // ignore: avoid_print
    print('Firebase app: name=${app.name} projectId=${app.options.projectId}');
  } catch (e) {
    // ignore: avoid_print
    print('Firebase init error: ' + e.toString());
    rethrow;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _themeProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Civic Resolve',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LoginScreen(),
    );
  }
}
