import 'package:flutter/material.dart';
import 'package:mindmatemobile/model/dashboard/day_items/day_item_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  DayItemDetails? _data;

  @override
  void initState() {
    super.initState();
  }

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> _fetchData(int id) async {
    final result = await _supabaseClient
        .from('moods')
        .select()
        .eq('id', id)
        .limit(1)
        .single();

    setState(() {
      _data = DayItemDetails(
          id: (result['id'] as int).toString(),
          createdAt: DateUtils.dateOnly(
              DateTime.parse(result['created_at'] as String)),
          userId: result['user_id'] as String,
          mood: result['mood'] as int,
          sleep: result['sleep'] as int,
          alcohol: result['alcohol'] as bool,
          exercise: result['exercise'] as bool,
          food: result['food'] as String,
          events: result['events'] as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    _fetchData(id);
    if (_data == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_data!.createdAt.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('Scor: '),
                Text(_data!.mood.toString())
              ]),
              Row(
                children: [
                  const Text('Somn: '),
                  Text(_data!.sleep.toString()),
                ],
              ),
              Row(children: [
                const Text('Alcool: '),
                Text(_data!.alcohol.toString())
              ]),
              Row(children: [
                const Text('Sport: '),
                Text(_data!.exercise.toString())
              ]),
              Row(children: [const Text('Mancare: '), Text(_data!.food)]),
              Row(children: [const Text('Evenimente: '), Text(_data!.events)]),
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
