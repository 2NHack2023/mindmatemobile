import 'package:flutter/material.dart';
import 'package:mindmatemobile/model/mood_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoodBarometer extends StatefulWidget {
  const MoodBarometer({super.key});

  @override
  State<MoodBarometer> createState() => _MoodBarometerState();
}

class _MoodBarometerState extends State<MoodBarometer> {
  var _mood = 0;
  var _sleep = 0;
  var _alcohol = false;
  var _exercise = false;
  var _food = '';
  var _events = '';
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  int _currentStep = 0;
  Future<void> _submitForm() async {
    MoodData moodData = MoodData(
        userId: _supabaseClient.auth.currentUser!.id,
        mood: _mood,
        sleep: _sleep,
        alcohol: _alcohol,
        exercise: _exercise,
        food: _food,
        events: _events);

    final List<Map<String, dynamic>> data =
        await _supabaseClient.from('moods').insert(moodData.toJson()).select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cum te simti azi?'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {
            if (_currentStep < 5) {
              _currentStep++;
            } else {
              _submitForm();
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep--;
            } else {
              Navigator.pop(context);
            }
          });
        },
        steps: [
          Step(
            title: const Text('Care este starea ta?'),
            content: Slider(
              value: _mood.toDouble(),
              min: -3,
              max: 3,
              divisions: 7,
              label: '$_mood',
              onChanged: (double newValue) {
                setState(() {
                  _mood = newValue.round();
                });
              },
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text('Cat ai dormit?'),
            content: Slider(
              value: _sleep.toDouble(),
              min: -1,
              max: 1,
              divisions: 3,
              label: '$_sleep',
              onChanged: (double newValue) {
                setState(() {
                  _sleep = newValue.round();
                });
              },
            ),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text('Ai baut alcool?'),
            content: Checkbox(
              value: _alcohol,
              onChanged: (bool? value) {
                setState(() {
                  _alcohol = value ?? false;
                });
              },
            ),
            isActive: _currentStep == 2,
          ),
          Step(
            title: const Text('Ai facut sport?'),
            content: Checkbox(
              value: _exercise,
              onChanged: (bool? value) {
                setState(() {
                  _exercise = value ?? false;
                });
              },
            ),
            isActive: _currentStep == 3,
          ),
          Step(
            title: const Text('Ce ai mancat azi (ex: dulciuri, carne, oua)?'),
            content: TextFormField(onChanged: (String? value) {
              setState(() {
                _food = value ?? '';
              });
            }, validator: (value) {
              if (_food.isEmpty) {
                return 'Te rog introdu detalii despre mancare';
              }
              return null;
            }),
            isActive: _currentStep == 4,
          ),
          Step(
            title: const Text('S-a intamplat ceva important azi?'),
            content: TextFormField(
              onChanged: (String? value) {
                setState(() {
                  _events = value ?? '';
                });
              },
            ),
            isActive: _currentStep == 5,
          ),
        ],
      ),
    );
  }
}
