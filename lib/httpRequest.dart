import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';

class HttpRequest extends StatefulWidget {
  HttpRequest({Key key}) : super(key: key);

  @override
  _HttpRequestState createState() => _HttpRequestState();
}

class _HttpRequestState extends State<HttpRequest> {
  double co2_val = 0.0;
  double temp_val = 0.0;
  int val1;
  int val2;
  @override
  void initState() {
    super.initState();
    setUpTimedFetch();
  }
  setUpTimedFetch() {
    Timer.periodic(Duration(seconds: 2), (timer) {
     
        fetchAlbum();
     
    });
  }

  void fetchAlbum() async {
    var data=jsonEncode({"Location":"belgavi,karnataka"});
    final response = await http.post(Uri.http("192.168.43.242:5000", "getSensorValues"),body: data,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    val1 = responseJson['result']['co2Value'];
    val2 = responseJson['result']['tempValue'];
    print(val1);
    print(val2);
    setState(() {
      co2_val = val1.toDouble();
      temp_val = val2.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Co2 Tracker ',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: new Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),

            // Co2 Container
            Text(
              "Co2 sensore Readings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            new Container(
                padding: EdgeInsets.all(10),
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[50],
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          // color: Colors.orange.shade200,
                          color: Colors.black12.withOpacity(0.6),
                          offset: Offset(3, 7),
                          blurRadius: 12.0,
                          spreadRadius: 2)
                    ]),
                child: SfRadialGauge(

                    // title: GaugeTitle(
                    //     text: 'Co2 Range',
                    //     textStyle: const TextStyle(
                    //         fontSize: 20.0, fontWeight: FontWeight.bold)),

                    axes: <RadialAxis>[
                      RadialAxis(
                          minimum: 100,
                          maximum: 2000,
                         
                          axisLineStyle: AxisLineStyle(
                              cornerStyle: CornerStyle.bothFlat,
                              color: Colors.black12,
                              thickness: 14),
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 100,
                                endValue: 600,
                                label: "Safe",
                                color: Colors.green,
                                startWidth: 20,
                                endWidth: 20),
                            GaugeRange(
                                startValue: 600,
                                endValue: 1000,
                                label: "Intermediate",
                                color: Colors.orange,
                                startWidth: 20,
                                endWidth: 20),
                            GaugeRange(
                                startValue: 1000,
                                endValue: 2000,
                                label: "Danger",
                                color: Colors.red,
                                startWidth: 20,
                                endWidth: 20)
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(value: co2_val, enableAnimation: true)
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child:  Text('$co2_val ppm',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                                angle: 90,
                                positionFactor: 0.8)
                          ])
                    ])),
            SizedBox(height: 30),

// temperature Container

            Text(
              "Temperature sensore Readings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[50],
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        // color: Colors.orange.shade200,
                        color: Colors.black12.withOpacity(0.6),
                        offset: Offset(3, 7),
                        blurRadius: 12.0,
                        spreadRadius: 2)
                  ]),
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                  ticksPosition: ElementsPosition.outside,
                  labelsPosition: ElementsPosition.outside,
                  minorTicksPerInterval: 5,
                  axisLineStyle: AxisLineStyle(
                    thicknessUnit: GaugeSizeUnit.factor,
                    thickness: 0.1,
                  ),
                  axisLabelStyle:
                      GaugeTextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  radiusFactor: 0.97,
                  majorTickStyle: MajorTickStyle(
                      length: 0.1,
                      thickness: 2,
                      lengthUnit: GaugeSizeUnit.factor),
                  minorTickStyle: MinorTickStyle(
                      length: 0.05,
                      thickness: 1.5,
                      lengthUnit: GaugeSizeUnit.factor),
                  minimum: 0,
                  maximum: 120,
                  interval: 10,
                  startAngle: 115,
                  endAngle: 65,
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: 120,
                        startWidth: 0.1,
                        sizeUnit: GaugeSizeUnit.factor,
                        endWidth: 0.1,
                        gradient: SweepGradient(stops: <double>[
                          0.2,
                          0.5,
                          0.75
                        ], colors: <Color>[
                          Colors.green,
                          Colors.yellow,
                          Colors.red
                        ]))
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: temp_val, enableAnimation: true)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          '$temp_val°C',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        positionFactor: 0.8,
                        angle: 90)
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
