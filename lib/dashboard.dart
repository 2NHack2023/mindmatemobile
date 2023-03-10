import 'package:flutter/material.dart';
import 'package:mindmatemobile/day_details_page.dart';
import 'package:mindmatemobile/loading.dart';
import 'package:mindmatemobile/model/dashboard/chart/chart_day.dart';
import 'package:mindmatemobile/model/dashboard/day_items/day_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  List<ChartDay> _dayRecords = List.empty();

  final List<DayItem> _listData = [];
  bool _stateSet = false;

  Future<void> _fetchData() async {
    final response = await _supabaseClient
        .from('moods')
        .select('id, created_at, mood')
        .eq('user_id', _supabaseClient.auth.currentUser!.id.toString())
        .gte(
            'created_at',
            DateUtils.dateOnly(
                DateTime.now().subtract(const Duration(days: 7))))
        .order('created_at', ascending: true);
    final records = response as List<dynamic>;
    setState(() {
      _dayRecords = records
          .map((record) => ChartDay(
              DateUtils.dateOnly(
                  DateTime.parse(record['created_at'] as String)),
              record['mood'] as int,
              id: record['id'] as int))
          .toList();

      var accountCreated = DateUtils.dateOnly(
          DateTime.parse(_supabaseClient.auth.currentUser!.createdAt));
      var diff = DateUtils.dateOnly(DateTime.now()).difference(accountCreated);

      var size = diff.inDays < 6 ? diff.inDays : 6;

      for (int i = 0; i <= size; i++) {
        var crtDate =
            DateUtils.dateOnly(DateTime.now().subtract(Duration(days: i)));
        var filled = false;
        int? id;
        for (var record in _dayRecords) {
          if (record.day.isAtSameMomentAs(crtDate)) {
            filled = true;
            id = record.id;
            break;
          }
        }
        _listData.add(DayItem(crtDate, filled, id));
      }
      _stateSet = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_stateSet) {
      return const Loading();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 200,
            child: charts.TimeSeriesChart(
              [
                charts.Series<ChartDay, DateTime>(
                  id: 'chart',
                  data: _dayRecords,
                  domainFn: (ChartDay dayItem, _) => dayItem.day,
                  measureFn: (ChartDay dayItem, _) => dayItem.mood,
                ),
              ],
              defaultRenderer: charts.BarRendererConfig<DateTime>(),
              animate: true,
              primaryMeasureAxis: const charts.NumericAxisSpec(
                tickProviderSpec: charts.StaticNumericTickProviderSpec(
                  <charts.TickSpec<num>>[
                    charts.TickSpec<num>(-3),
                    charts.TickSpec<num>(-2),
                    charts.TickSpec<num>(-1),
                    charts.TickSpec<num>(0),
                    charts.TickSpec<num>(1),
                    charts.TickSpec<num>(2),
                    charts.TickSpec<num>(3),
                  ],
                ),
              ),
              domainAxis: const charts.DateTimeAxisSpec(
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                      format: 'd', transitionFormat: 'dd/MM/yyyy'),
                ),
                tickProviderSpec: charts.DayTickProviderSpec(
                  increments: [1, 5],
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: _listData.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _listData[index];
              return Container(
                color: !item.filled ? Colors.red : Colors.white,
                child: ListTile(
                    title: Text(
                        DateTime(item.date.year, item.date.month, item.date.day)
                            .toString()),
                    onTap: () {
                      if (item.filled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(id: item.id!),
                          ),
                        );
                      }
                    }),
              );
            },
          ))
        ]),
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
