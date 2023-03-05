import 'dart:ffi';

class MoodData {
  String userId;
  int mood;
  int sleep;
  bool alcohol;
  bool exercise;
  String food;
  String events;

  MoodData(
      {required this.userId,
      required this.mood,
      required this.sleep,
      required this.alcohol,
      required this.exercise,
      required this.food,
      required this.events});

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'mood': mood,
        'sleep': sleep,
        'alcohol': alcohol,
        'exercise': exercise,
        'food': food,
        'events': events
      };
}
