
enum BannerType { regularBanner, defaultBanner }

class Banners {
  final String? id;
  final String? media;
  final String? url;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<String>? dashboardTarget;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  Banners({
    this.id,
    this.media,
    this.url,
    this.fromDate,
    this.toDate,
    this.dashboardTarget,
    this.dateAdded,
    this.dateUpdated,
  });

  factory Banners.fromJson(Map<String, dynamic> json) {
    return Banners(
      id: json['id'],
      media: json['media'],
      url: json['url'],
      fromDate: json['from_date'] != null
          ? DateTime.parse(json['from_date'])
          : null,
      toDate: json['to_date'] != null
          ? DateTime.parse(json['to_date'])
          : null,
      dashboardTarget: json['dashboard_target'] != null
          ? List<String>.from(json['dashboard_target'])
          : [],
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
      'media': media,
      'url': url,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'dashboard_target': dashboardTarget,
      'date_added': dateAdded?.toIso8601String(),
      'date_updated': dateUpdated?.toIso8601String(),
    };
  }

  static List<Banners> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Banners.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}