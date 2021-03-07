double convertDouble(dynamic value) => value is double
    ? value
    : double.tryParse(value) == null ? 0 : double.parse(value);
