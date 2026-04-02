class Batch {
  final String id;
  final String name;
  final String code;
  final String status; // active / inactive

  Batch({
    required this.id,
    required this.name,
    required this.code,
    required this.status,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        status: json['status'],
      );
}
