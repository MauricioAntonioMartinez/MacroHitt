import 'package:flutter/material.dart';

import './validation.dart';

Map<String, dynamic> createRecipe() {
  return {
    'field': 'recipeName',
    'label': 'Recipe Name',
    'placeholder': ' - ',
    'validator': textValidator,
    'keyboard': TextInputType.text,
    'initialValue': ''
  };
}
