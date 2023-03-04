import 'package:flutter/material.dart';
import 'package:mindmatemobile/supabase_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindMate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are logged in!'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await supabaseClient.auth.signOut();
                // Navigate to login page after sign out
              },
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}
