class Notifications {
  final String id;
  final String title;
  final String message;
  final List<String> dashboardTarget;
  final String dateAdded;
  final String dateUpdated;
  final bool isImportant;
  final String objectId;

  Notifications({
    required this.id,
    required this.title,
    required this.message,
    required this.dashboardTarget,
    required this.dateAdded,
    required this.dateUpdated,
    required this.isImportant,
    required this.objectId,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {

    return Notifications(
      id: json['id'] ?? '',

      title: json['title'] ?? '',

      message: json['message'] ?? '',

      dashboardTarget:
          json['dashboard_target'] is List
              ? List<String>.from(json['dashboard_target'])
              : json['dashboard_target'] != null
                  ? [json['dashboard_target'].toString()]
                  : [],

      dateAdded: json['date_added'] ?? '',

      dateUpdated: json['date_updated'] ?? '',

      isImportant: json['is_important'] ?? false,

      objectId: json['object_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'dashboard_target': dashboardTarget,
      'date_added': dateAdded,
      'date_updated': dateUpdated,
      'is_important': isImportant,
      'object_id': objectId,
    };
  }
}