import 'package:flutter/material.dart';

import './validation.dart';

Map<String, dynamic> createRecipie() {
  return {
    'field': 'recipieName',
    'label': 'Recipie Name',
    'placeholder': ' - ',
    'validator': textValidator,
    'keyboard': TextInputType.text,
    'initialValue': ''
  };
}
