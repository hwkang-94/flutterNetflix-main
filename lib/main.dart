import 'package:clonenetflix/screen/SearchScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:clonenetflix/widget/bottom_bar.dart';
import 'package:clonenetflix/screen/home_screen.dart';

/* void main() => runApp(MyApp());*/

void main() async {
  // 앱 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //TabController controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: TabBarView(
            //AlwaysScrollableScrollPhysics() => scroll Avaliable
            //NeverScrollableScrollPhysics() => scroll not Avaliable
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              HomeScreen(),
              SearchScreen(),
              Container(child: Center(child: Text('save'),),),
              Container(child: Center(child: Text('more'),),),
            ],
          ),
          bottomNavigationBar: Bottom(),
        ),
      ),
    );
  }
}
