import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/colors.dart';
import 'core/config.dart';
import 'service/auth_service.dart';
import 'view/pages/login_page.dart';
import 'view/pages/root_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>(kUsersBox);
  await Hive.openBox<String>(kSavedBox);
  final isLoggedIn = await AuthService.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
        colorScheme: const ColorScheme.dark(primary: kAccent),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackground,
          foregroundColor: Colors.white,
        ),
      ),
      home: isLoggedIn ? const RootPage() : const LoginPage(),
    );
  }
}
