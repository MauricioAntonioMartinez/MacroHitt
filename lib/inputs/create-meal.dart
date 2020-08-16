import './validation.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> mealInfo(Map<String, dynamic> meal) => [
      {
        'field': 'mealName',
        'label': 'Meal Name',
        'placeholder': 'Eggs ...',
        'validator': textValidator,
        'keyboard': TextInputType.text,
        'initialValue': meal['mealName']
      },
      {
        'field': 'brandName',
        'label': 'Brand Name',
        'placeholder': 'San Juan ...',
        'validator': textValidator,
        'keyboard': TextInputType.text,
        'initialValue': meal['brandName']
      },
      {
        'field': 'servingSize',
        'label': 'Serving Size',
        'placeholder': '100',
        'validator': numberValidator,
        'keyboard': TextInputType.number,
        'initialValue': meal['servingSize']
      },
      {
        'field': 'servingName',
        'label': 'Serving Name',
        'placeholder': 'grams',
        'validator': textValidator,
        'keyboard': TextInputType.text,
        'initialValue': meal['servingName']
      },
    ];
List<Map<String, dynamic>> macros(Map<String, dynamic> meal) => [
      {
        'field': 'protein',
        'label': 'Protein',
        'placeholder': '80g',
        'validator': numberValidator,
        'keyboard': TextInputType.number,
        'initialValue': meal['protein']
      },
      {
        'field': 'carbs',
        'label': 'Carbs',
        'placeholder': '20g',
        'keyboard': TextInputType.number,
        'validator': numberValidator,
        'initialValue': meal['carbs']
      },
      {
        'field': 'fats',
        'label': 'Fats',
        'placeholder': '5g',
        'keyboard': TextInputType.number,
        'validator': numberValidator,
        'initialValue': meal['fats']
      },
    ];
List<Map<String, dynamic>> details(Map<String, dynamic> meal) => [
      {
        'field': 'sugar',
        'label': 'Sugar',
        'placeholder': '1g',
        'keyboard': TextInputType.number,
        'validator': (v) => v.isEmpty ? null : numberValidator(v),
        'initialValue': meal['sugar']
      },
      {
        'field': 'fiber',
        'label': 'Fiber',
        'placeholder': '1g',
        'keyboard': TextInputType.number,
        'validator': (v) => v.isEmpty ? null : numberValidator(v),
        'initialValue': meal['fiber']
      },
      {
        'field': 'saturatedFat',
        'label': 'Saturated ',
        'placeholder': '1g',
        'keyboard': TextInputType.number,
        'validator': (v) => v.isEmpty ? null : numberValidator(v),
        'initialValue': meal['saturatedFat']
      },
      {
        'field': 'monosaturatedFat',
        'label': 'Monosaturated',
        'placeholder': '1g',
        'keyboard': TextInputType.number,
        'validator': (v) => v.isEmpty ? null : numberValidator(v),
        'initialValue': meal['monosaturatedFat']
      },
      {
        'field': 'polyunsaturatedFat',
        'label': 'Polyunsaturated',
        'placeholder': '5g',
        'keyboard': TextInputType.number,
        'validator': (v) => v.isEmpty ? null : numberValidator(v),
        'initialValue': meal['polyunsaturatedFat']
      },
    ];
