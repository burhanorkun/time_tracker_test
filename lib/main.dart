import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_test/app/landing_page.dart';
import 'package:time_tracker_test/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      builder: (context)=>Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
