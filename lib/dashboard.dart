import 'package:flutter/material.dart';
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

  _DashboardState() {
    _fetchData();
  }

  List<ChartDay> _dayRecords = List.empty();

  final List<DayItem> _listData = [];

  Future<void> _fetchData() async {
    final response = await _supabaseClient
        .from('moods')
        .select('created_at, mood')
        .eq('user_id', _supabaseClient.auth.currentUser!.id.toString())
        .gte('created_at',
            DateUtils.dateOnly(DateTime.now().subtract(Duration(days: 7))))
        .order('created_at', ascending: true);
    final records = response as List<dynamic>;
    setState(() {
      _dayRecords = records
          .map((record) => ChartDay(
                DateUtils.dateOnly(
                    DateTime.parse(record['created_at'] as String)),
                record['mood'] as int,
              ))
          .toList();

      for (int i = 0; i <= 6; i++) {
        var crtDate =
            DateUtils.dateOnly(DateTime.now().subtract(Duration(days: i)));
        var filled = false;
        for (var record in _dayRecords) {
          if (record.day.isAtSameMomentAs(crtDate)) {
            filled = true;
            break;
          }
        }
        _listData.add(DayItem(crtDate, filled));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: _listData.length,
          itemBuilder: (BuildContext context, int index) {
            final item = _listData[index];
            return ListTile(
                title: Text(
                    DateTime(item.date.year, item.date.month, item.date.day)
                        .toString()),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/details',
                      arguments: 2);
                });
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
