import 'dart:core';

class DayItemDetails {
  String id;
  String userId;
  int mood;
  int sleep;
  bool alcohol;
  bool exercise;
  String food;
  String events;
  DateTime createdAt;

  DayItemDetails(
      {required this.id,
      required this.createdAt,
      required this.userId,
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
