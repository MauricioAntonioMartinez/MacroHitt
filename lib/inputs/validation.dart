String numberValidator(String value) {
  if (value.trim().isEmpty) {
    return 'Field required';
  } else if (double.tryParse(value) == null)
    return 'Invalid input';
  else if (double.tryParse(value) < 0) return 'Must be positive';
  return null;
}

String textValidator(String value) {
  if (value.isEmpty) {
    return 'Field required';
  } else if (value.length < 3) return 'Value too short';
  return null;
}
