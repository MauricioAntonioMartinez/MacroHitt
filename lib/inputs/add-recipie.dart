import './validation.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> createRecipie(Map<String, dynamic> recipie) {
  return {
    'field': 'recipieName',
    'label': 'Recipie Name',
    'placeholder': ' - ',
    'validator': textValidator,
    'keyboard': TextInputType.text,
    'initialValue': recipie['recipieName']
  };
}
