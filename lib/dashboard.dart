import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your history'),
      ),
      body: const Center(
        child: Text(
          'Your history',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _supabaseClient.auth.signOut();
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
