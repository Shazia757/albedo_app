class RatingValue {
  final int id;
  final RatingValues values;
  final String validFrom;

  RatingValue({
    required this.id,
    required this.values,
    required this.validFrom,
  });

  factory RatingValue.fromJson(Map<String, dynamic> json) {
    return RatingValue(
      id: json['id'],
      values: RatingValues.fromJson(json['values']),
      validFrom: json['valid_from'],
    );
  }
}

class RatingValues {
  final double mv1;
  final double mv2;
  final double mv3;
  final double mv4;
  final double mv5;

  RatingValues({
    required this.mv1,
    required this.mv2,
    required this.mv3,
    required this.mv4,
    required this.mv5,
  });

  factory RatingValues.fromJson(Map<String, dynamic> json) {
    return RatingValues(
      mv1: (json['mv1'] as num).toDouble(),
      mv2: (json['mv2'] as num).toDouble(),
      mv3: (json['mv3'] as num).toDouble(),
      mv4: (json['mv4'] as num).toDouble(),
      mv5: (json['mv5'] as num).toDouble(),
    );
  }
}