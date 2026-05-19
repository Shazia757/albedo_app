class Syllabus {
  final String id;
  final String name;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  Syllabus({
    required this.id,
    required this.name,
    this.dateAdded,
    this.dateUpdated,
  });

  factory Syllabus.fromJson(Map<String, dynamic> json) {
    return Syllabus(
      id: json['id'],
      name: json['name'],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
    };
  }

  Syllabus copyWith({
    String? id,
    String? name,
  }) {
    return Syllabus(
      id: id ?? this.id,
      name: name ?? this.name,
      dateAdded: dateAdded,
      dateUpdated: dateUpdated,
    );
  }
}

class CompletionDeadline {
  final String? id;
  final String? role;
  final String? deadlineType;
  final int? value;
  final bool? isActive;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  CompletionDeadline({
    this.id,
    this.role,
    this.deadlineType,
    this.value,
    this.isActive,
    this.dateAdded,
    this.dateUpdated,
  });

  factory CompletionDeadline.fromJson(Map<String, dynamic> json) {
    return CompletionDeadline(
      id: json['id'],
      role: json['role'],
      deadlineType: json['deadline_type'],
      value: json['value'],
      isActive: json['is_active'],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
      dateUpdated: json['date_updated'] != null
          ? DateTime.parse(json['date_updated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'deadline_type': deadlineType,
      'value': value,
      'is_active': isActive,
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
    };
  }

  static List<CompletionDeadline> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => CompletionDeadline.fromJson(e as Map<String, dynamic>))
        .toList();
  }

CompletionDeadline copyWith({
  String? id,
  String? role,
  String? deadlineType,
  int? value,
  bool? isActive,
  DateTime? dateAdded,
  DateTime? dateUpdated,
}) {
  return CompletionDeadline(
    id: id ?? this.id,
    role: role ?? this.role,
    deadlineType: deadlineType ?? this.deadlineType,
    value: value ?? this.value,
    isActive: isActive ?? this.isActive,
    dateAdded: dateAdded ?? this.dateAdded,
    dateUpdated: dateUpdated ?? this.dateUpdated,
  );
}}

class AssessmentAttentionQns {
  final String? id;
  final String? value;
  final DateTime? dateAdded;

  AssessmentAttentionQns({
    this.id,
    this.value,
    this.dateAdded,
  });

  factory AssessmentAttentionQns.fromJson(Map<String, dynamic> json) {
    return AssessmentAttentionQns(
      id: json['id'],
      value: json['value'],
      dateAdded: json['date_added'] != null
          ? DateTime.parse(json['date_added'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'date_added': dateAdded?.toIso8601String(),
    };
  }

  static List<AssessmentAttentionQns> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => AssessmentAttentionQns.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  AssessmentAttentionQns copyWith({
    String? id,
    String? value,
  }) {
    return AssessmentAttentionQns(
      id: id ?? this.id,
      value: value ?? this.value,
      dateAdded: dateAdded,
    );
  }
}
