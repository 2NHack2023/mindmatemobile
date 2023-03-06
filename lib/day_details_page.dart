import 'package:flutter/material.dart';
import 'package:mindmatemobile/loading.dart';
import 'package:mindmatemobile/model/dashboard/day_items/day_item_details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  DayItemDetails? _data;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.id);
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
    if (_data == null) {
      return const Loading();
    } else {
      var dateSelected = _data!.createdAt;
      return Scaffold(
        appBar: AppBar(
          title: Text(
              "${dateSelected.year}-${dateSelected.month.toString().padLeft(2, '0')}-${dateSelected.day.toString().padLeft(2, '0')}"),
        ),
        body: Center(
          child: SizedBox(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(children: [
                          const Text('Scor: '),
                          Text(_data!.mood.toString())
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(
                          children: [
                            const Text('Somn: '),
                            Text(_data!.sleep.toString()),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(children: [
                          const Text('Alcool: '),
                          Text(_data!.alcohol.toString())
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(children: [
                          const Text('Sport: '),
                          Text(_data!.exercise.toString())
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(children: [
                          const Text('Mancare: '),
                          Text(_data!.food)
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Row(children: [
                          const Text('Evenimente: '),
                          Text(_data!.events)
                        ]),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Inapoi'))
                      ],
                    )
                  ],
                ),
              ),
            ),
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
