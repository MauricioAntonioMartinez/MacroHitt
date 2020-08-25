import 'package:HIIT/bloc/Repositories/goals-repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/bloc.dart';
import './BlocObserver.dart';
import 'bloc/Repositories/index.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(BlocProvider(
      create: (context) {
        return MealBloc(mealItemRepository: MealItemRepository())
          ..add(MealLoad());
      },
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//#42C9B7
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<TrackBloc>(
          create: (_) => TrackBloc(
              mealBloc: BlocProvider.of<MealBloc>(context),
              trackRepository: TrackRepository(),
              trackItemRepository: TrackItemRepository()),
        ),
        BlocProvider<GoalBloc>(
          create: (_) => GoalBloc(goalsRepository: GoalItemRepository()),
        )
      ],
      child: MaterialApp(
        title: 'Macro Hitt',
        theme: ThemeData(
            fontFamily: 'Questrial',
            primarySwatch: Colors.teal,
            accentColor: Colors.blueAccent,
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
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Questrial'),
                subhead: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Questrial'),
                body2: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
                body1: TextStyle(fontSize: 16, fontWeight: FontWeight.w100))),
        home: MainScreen(),
        routes: {
          Search.routeName: (ctx) => Search(),
          MealPreview.routeName: (ctx) => MealPreview(),
          EditMeal.routeName: (ctx) => EditMeal(),
          AddGoalWidget.routName: (ctx) => AddGoalWidget(),
        },
        onGenerateRoute: (settings) {
          print(settings);
        },
      ),
    );
  }
}
