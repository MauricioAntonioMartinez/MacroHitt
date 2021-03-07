import './validation.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> createGoal(Map<String, dynamic> goal) => [
      {
        'field': 'goalName',
        'label': 'Goal Name',
        'placeholder': ' - ',
        'validator': textValidator,
        'keyboard': TextInputType.text,
        'initialValue': goal['goalName']
      },
      {
        'field': 'protein',
        'label': 'Protein',
        'placeholder': ' - ',
        'validator': numberValidator,
        'keyboard': TextInputType.number,
        'initialValue': goal['protein']
      },
      {
        'field': 'carbs',
        'label': 'Carbs',
        'placeholder': '20g',
        'keyboard': TextInputType.number,
        'validator': numberValidator,
        'initialValue': goal['carbs']
      },
      {
        'field': 'fats',
        'label': 'Fats',
        'placeholder': '5g',
        'keyboard': TextInputType.number,
        'validator': numberValidator,
        'initialValue': goal['fats']
      },
    ];
