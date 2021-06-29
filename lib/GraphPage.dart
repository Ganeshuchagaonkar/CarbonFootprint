import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  GraphPage({Key key}) : super(key: key);
  @override
  @override
  _GraphPageState createState() => _GraphPageState();
}

final TextEditingController _dateController = TextEditingController();

class _GraphPageState extends State<GraphPage> {
  String date;
  List<_Co2Data> list = [];
  double todays_max = 00;
  double todays_min = 00;
  double overall_max = 00;
  double overall_min = 00;
  String maxdate;
  String mindate;
  var xvalue = [];
  var yvalue = [];

  void initState() {
    super.initState();
  }

  void fetchSensoreValue(
    String date,
  ) async {
    list.clear();

    var data = jsonEncode({"Date": date, "Location": "belgaum,Karnataka"});
    final res = await http.post(
      Uri.http("192.168.43.187:5000", "dashboard"),
      body: data,
      headers: <String, String>{
        "content-Type": "application/json; charset=utf-8",
      },
    );

    final responseJson = jsonDecode(res.body);
    var extremesvalues = responseJson['data'];

    setState(() {
      xvalue = responseJson['data']['x_values'];
      yvalue = responseJson['data']['y_values'];
      // Overall Extremes.
      overall_min = extremesvalues['overall_extremes']['minvalue'].toDouble();
      overall_max = extremesvalues['overall_extremes']['maxvalue'].toDouble();
      String str1 = extremesvalues['overall_extremes']['maxdate'].toString();
      String str2 = extremesvalues['overall_extremes']['mindate'].toString();
      maxdate = str1.substring(0, 16);
      mindate = str2.substring(0, 16);
      // Todays Extremes
      todays_max = extremesvalues['today_extremes']['maxvalue'].toDouble();
      todays_min = extremesvalues['today_extremes']['minvalue'].toDouble();
    });

    createData();
 
  }

  void createData() {
    for (var i = 0; i < xvalue.length; i++) {
      list.add(_Co2Data(xvalue[i].toString(), yvalue[i].toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text(
            'Graph Page',
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        drawer: new Drawer(
          child: ListView(
            children: [
              SizedBox(height: 60),
              Divider(),
              ListTile(
                title: Text("DashBoard"),
                onTap: () {
                  Navigator.pushNamed(context, '/DashBoard');
                },
              ),
              Divider(),
              ListTile(
                  title: Text("View Graph"),
                  onTap: () {
                    Navigator.pushNamed(context, '/ViewGraph');
                  }),
              Divider(),
              ListTile(
                title: Text("Cancel"),
                trailing: Icon(Icons.cancel),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: Container(
          padding:
              const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 15),
          child: SingleChildScrollView(
              child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: TextFormField(
                        controller: _dateController,
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Select the date to view the graph',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        primary: Colors.white,
                        onSurface: Colors.grey),
                    onPressed: () => {
                          date = _dateController.text,
                          fetchSensoreValue(date),
                        },
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            ),
            SizedBox(height: 20),
            //Initialize the chart widget
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 15),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Co2 values vs time'),
                  
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<_Co2Data, String>>[
                    LineSeries<_Co2Data, String>(
                        dataSource: list,
                        xValueMapper: (_Co2Data values, _) => values.time,
                        yValueMapper: (_Co2Data values, _) => values.co2_value,
                        // name: 'Y values',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
            ),

            SizedBox(height: 30),
            Container(
                height: 150,
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.4),
                          offset: Offset(3, 7),
                          blurRadius: 12.0,
                          spreadRadius: 2)
                    ]),
                child: Column(
                  children: [
                    Text(
                      "Todays Data",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "High",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "$todays_max ppm",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Low",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.teal),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "$todays_min ppm",
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 30),
            Container(
                height: 180,
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.4),
                          offset: Offset(3, 7),
                          blurRadius: 12.0,
                          spreadRadius: 2)
                    ]),
                child: Column(
                  children: [
                    Text(
                      "Overall Data",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "High",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.redAccent),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "$overall_max ppm",
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "$maxdate",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Low",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.teal),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "$overall_min ppm",
                                style: TextStyle(fontSize: 17),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "$mindate",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 20)
          ])),
        ));
  }
}

class _Co2Data {
  _Co2Data(this.time, this.co2_value);

  final double co2_value;
  final String time;
}

_selectDate(BuildContext context) async {
  var _selectedDate;
  DateTime newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.blue,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      });

  if (newSelectedDate != null) {
    _selectedDate = newSelectedDate;
    _dateController
      ..text = DateFormat("yyyy-MM-dd").format(_selectedDate)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: _dateController.text.length,
          affinity: TextAffinity.upstream));
  }
}
