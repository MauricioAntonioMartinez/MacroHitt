import 'package:HIIT/bloc/Repositories/goals-repository.dart';
import 'package:HIIT/bloc/Repositories/recipe-item-repository.dart';
import 'package:HIIT/bloc/Repositories/recipe-repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import './BlocObserver.dart';
import './bloc/bloc.dart';
import './screens/index.dart';
import 'bloc/Repositories/index.dart';
import 'bloc/Track/track_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(BlocProvider(
      create: (context) {
        return MealBloc(
            mealItemRepository: MealItemRepository(),
            recipeRepository: RecipeRepository(),
            trackRepository: TrackRepository())
          ..add(MealLoad());
      },
      child: BlocProvider<RecipeBloc>(
        create: (context) => RecipeBloc(
          mealBloc: BlocProvider.of<MealBloc>(context),
          recipeItemRepository: RecipeItemRepository(),
          recipeRepository: RecipeRepository(),
        )..add(LoadRecipes()),
        child: MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//#42C9B7
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      BlocProvider.of<RecipeBloc>(context).add(LoadRecipes());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<TrackBloc>(
          create: (_) => TrackBloc(
              mealBloc: BlocProvider.of<MealBloc>(context),
              trackRepository: TrackRepository(),
              trackItemRepository: TrackItemRepository(),
              recipeBloc: BlocProvider.of<RecipeBloc>(context)),
        ),
        BlocProvider<GoalBloc>(
          create: (_) => GoalBloc(goalsRepository: GoalItemRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Macro Hitt',
        theme: ThemeData(
            fontFamily: 'Questrial',
            primaryColor: Color(0xFF00E5FF),
            accentColor: Colors.blueAccent,
            textTheme: ThemeData.light().textTheme.copyWith(
                caption: TextStyle(fontSize: 16),
                headline6: TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(204, 0, 11, 0.8)),
                subtitle2: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Questrial'),
                subtitle1: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Questrial'),
                bodyText1: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00E5FF)),
                bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.w100))),
        home: MainScreen(),
        routes: {
          Search.routeName: (ctx) => Search(),
          MealPreview.routeName: (ctx) => MealPreview(),
          EditMeal.routeName: (ctx) => EditMeal(),
          AddGoalWidget.routName: (ctx) => AddGoalWidget(),
          AddRecipeWidget.routeName: (ctx) => AddRecipeWidget()
        },
        onGenerateRoute: (settings) {
          print(settings);
        },
      ),
    );
  }
}
