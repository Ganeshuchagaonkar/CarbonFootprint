import 'dart:async';
import 'dart:io';
import 'package:co2tracker/httpRequest.dart';
import 'package:co2tracker/Login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HttpRequest());
  }
}

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
 @override
  void initState() { 
    super.initState();
    Timer(Duration(seconds: 5), ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage())));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         shape:BoxShape.circle,
                      //       ),
                      //       child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQokILUWOSE0fcDbXaPSqgjdwoGZdOmAr9J-Q&usqp=CAU"),

                      //     )
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80.0,
                          child: Image.network(
                            "",
                          )
                          // Icon(Icons.shopping_cart),
                          ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Co2Tracker",style: TextStyle(fontSize:30.0,color:Colors.black,fontWeight:FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding:EdgeInsets.only(top:20.0)),
                    Text("Guided by Dr.Kuldeep Sambrekar ",style:TextStyle(
                      color:Colors.black,
                      fontSize: 18.0,fontWeight: FontWeight.bold
                    )),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
