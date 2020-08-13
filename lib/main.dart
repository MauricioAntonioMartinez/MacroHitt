import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/bloc.dart';
import './BlocObserver.dart';
import './screens/search.dart';
import './screens/meal_preview.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(BlocProvider(
      create: (context) {
        return MealBloc()..add(MealLoad());
      },
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<TrackBloc>(
          create: (_) =>
              TrackBloc(mealBloc: BlocProvider.of<MealBloc>(context)),
        )
      ],
      child: MaterialApp(
        title: 'Macro Hitt',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.blueAccent,
            fontFamily: 'Questrial',
            textTheme: ThemeData.light().textTheme.copyWith(
                  caption: TextStyle(fontSize: 16),
                  title: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(204, 0, 11, 0.8)),
                  subtitle: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w300),
                  subhead: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Questrial'),
                )),
        home: MainScreen(),
        routes: {
          Search.routeName: (ctx) => Search(),
          MealPreview.routeName: (ctx) => MealPreview()
        },
        onGenerateRoute: (settings) {
          print(settings);
        },
      ),
    );
  }
}
