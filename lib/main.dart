import 'package:flutter/material.dart';
import 'package:mindmatemobile/supabase_config.dart';
import 'package:supabase/supabase.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  runApp(MyApp(supabaseClient: supabaseClient));
}

class MyApp extends StatefulWidget {
  final SupabaseClient supabaseClient;

  const MyApp({Key? key, required this.supabaseClient}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthChangeEvent _authChangeEvent;

  @override
  void initState() {
    super.initState();
    _authChangeEvent =
        widget.supabaseClient.auth.onAuthStateChange.listen((session) {
      setState(() {});
    }) as AuthChangeEvent;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.supabaseClient.auth.currentSession != null;

    return MaterialApp(
      title: 'Supabase Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn
          ? const HomePage(
              title: 'MindMate',
            )
          : const LoginPage(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
      },
    );
  }
}
