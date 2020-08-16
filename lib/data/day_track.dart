import '../bloc/Model/model.dart';

List<Track> trakDays = [
  Track(date: DateTime(2020, 1, 2), goals: Macro(20, 50, 100), mealGroup: {
    MealGroupName.BreakFast: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ],
    MealGroupName.Lunch: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ],
    MealGroupName.Dinner: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ]
  }),
  Track(date: DateTime(2020, 1, 3), goals: Macro(20, 50, 100), mealGroup: {
    MealGroupName.BreakFast: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ],
    MealGroupName.Lunch: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ],
    MealGroupName.Dinner: [
      MealTrack(id: '1', qty: 100),
      MealTrack(id: '2', qty: 100),
      MealTrack(id: '3', qty: 100),
    ]
  }),
  Track(date: DateTime.now(), goals: Macro(20, 50, 100), mealGroup: {
    //  MealGroupName.BreakFast: []
    //   MealTrack(id: '1', qty: 80),
    //   MealTrack(id: '2', qty: 10),
    //   MealTrack(id: '3', qty: 20),
    // ],
    // MealGroupName.Lunch: [
    //   MealTrack(id: '4', qty: 100),
    //   MealTrack(id: '5', qty: 100),
    //   MealTrack(id: '6', qty: 100),
    // ],
    // MealGroupName.Dinner: [
    //   MealTrack(id: '7', qty: 100),
    //   MealTrack(id: '8', qty: 100),
    //   MealTrack(id: '9', qty: 100),
    // ]
  })
];
