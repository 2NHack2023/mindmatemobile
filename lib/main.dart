import 'package:flutter/material.dart';
import 'package:mindmatemobile/dashboard.dart';
import 'package:mindmatemobile/mood_barometer.dart';
import 'package:mindmatemobile/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'signup_page.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Supabase Login Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/login': (_) => const LoginPage(),
          '/signup': (_) => const SignUpPage(),
          '/home': (_) => const MoodBarometer(),
          '/dashboard': (_) => const Dashboard(),
        },
        initialRoute: '/login',
        home: const LoginPage());
  }
}
