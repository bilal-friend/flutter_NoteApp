import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/editor/editor.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/auth/register.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/categories/add.dart';
import 'package:flutter_application_1/note/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('========== User is currently signed out!');
      } else {
        print('========== User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            color: Colors.orange[400],
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.orange[400]),
        ),
      ),
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomePage()
          : const LoginPage(),

      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/addCategory': (context) => const addCategory(),
        '/view': (context) => const ViewPage(),
        '/editor': (context) => Editor(),
      },
    );
  }
}
