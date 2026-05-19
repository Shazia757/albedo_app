class Terms {
  final String? id;
  final String? userType;
  final String? content;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  Terms({
    this.id,
    this.userType,
    this.content,
    this.dateAdded,
    this.dateUpdated,
  });

  factory Terms.fromJson(Map<String, dynamic> json) {
    return Terms(
      id: json['id'],
      userType: json['user_type'],
      content: json['content'],
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
      'user_type': userType,
      'content': content,
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
    };
  }

  Terms copyWith({
    String? id,
    String? userType,
    String? content,
    DateTime? dateAdded,
    DateTime? dateUpdated,
  }) {
    return Terms(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      content: content ?? this.content,
      dateAdded: dateAdded ?? this.dateAdded,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  static List<Terms> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Terms.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}