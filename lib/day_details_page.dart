import 'package:flutter/material.dart';
import 'package:mindmatemobile/model/dashboard/day_items/day_item_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatefulWidget {
  final int id;

  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var data = DayItemDetails(
      id: 'id',
      createdAt: DateTime.now(),
      userId: 'userId',
      mood: 0,
      sleep: 0,
      alcohol: false,
      exercise: false,
      food: 'food',
      events: 'events');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> fetchData() async {}

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(data!.createdAt.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [const Text('Scor: '), Text(data.mood.toString())]),
              Row(
                children: [
                  const Text('Somn: '),
                  Text(data.sleep.toString()),
                ],
              ),
              Row(children: [Text('Alcool: '), Text(data.alcohol.toString())]),
              Row(children: [Text('Sport: '), Text(data.exercise.toString())]),
              Row(children: [Text('Mancare: '), Text(data.food)]),
              Row(children: [Text('Evenimente: '), Text(data.events)]),
            ],
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
}
