import 'package:flutter/material.dart';
import './screens/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Macro Hitt',
      theme: ThemeData(
          fontFamily: 'Questrial',
          primarySwatch: Colors.teal,
          textTheme: ThemeData.light().textTheme.copyWith(
              caption: TextStyle(fontSize: 16),
              title: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
              subtitle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
              subhead: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Questrial'))),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MainScreen(),
      },
      onGenerateRoute: (settings) {
        print(settings);
      },
    );
  }
}
