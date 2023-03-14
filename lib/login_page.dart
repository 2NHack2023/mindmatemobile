import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    late AuthResponse response;
    try {
      response = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      if (response.session != null) {
        final response = await _supabaseClient
            .from('moods')
            .select('id')
            .eq('user_id', _supabaseClient.auth.currentUser!.id.toString())
            .gte('created_at', DateUtils.dateOnly(DateTime.now()))
            .limit(1);
        if (response != null && response.length > 0) {
          _navigateTo('/dashboard');
        } else {
          _navigateTo('/home');
        }
      }
    } catch (error) {
      showErrorSnackBar('Eroare la conectare');
    }
  }

  Future<void> _navigateTo(String routeName) async {
    Navigator.pushReplacementNamed(context, routeName);
  }

  void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectare'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Adresa email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Adresa de email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Parola'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Parola';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: const Text('Log in'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _navigateTo('/signup'),
                child: const Text('Inregistrare'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
