import 'package:anton_camera/plot_api.dart';
import 'package:anton_camera/plot_page.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CalendarPage> {
  List<DateTime> _dates = [];

  final PlotApi api = PlotApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoButton(
            color: Colors.deepPurple,
            child: const Text("Выбрать диапазон дат"),
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                  calendarType: CalendarDatePicker2Type.range,
                ),
                dialogSize: const Size(500, 500),
                borderRadius: BorderRadius.circular(15),
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                _dates = [];
                for (var date in values) {
                  if (date != null) {
                    _dates.add(date);
                  }
                }
                if (_dates.length == 1) {
                  _dates.add(_dates.first);
                }
                Future<Map<String, dynamic>?> apiResult = api.getPlot(_dates);
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PlotPage(apiResult: apiResult, dates: _dates)));
              }
            }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
