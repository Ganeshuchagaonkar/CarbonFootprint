import 'dart:async';
import 'dart:io';
import 'package:co2tracker/httpRequest.dart';
import 'package:co2tracker/Login.dart';
import 'package:flutter/material.dart';
import'package:co2tracker/GraphPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        routes: {
          '/DashBoard':(context)=>HttpRequest(),
          '/ViewGraph':(context)=>GraphPage()
        },
        theme: ThemeData(
         
          // is not restarted.
          primarySwatch: Colors.blue,
          
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  Splashscreen());
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
                      //   
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80.0,
                          child: Image.asset(
                            "images/logo.png",
                          )
                          
                          ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Carbon Footprint",style: TextStyle(fontSize:30.0,color:Colors.white,fontWeight:FontWeight.bold),)
                    ],
                  ),
                ),
              ),
              Expanded(
                flex:1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(   valueColor:AlwaysStoppedAnimation<Color>(Colors.white),),
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
