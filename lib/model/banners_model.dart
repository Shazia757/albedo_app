import 'package:albedo_app/controller/settings_controller.dart';

enum BannerType { regularBanner, defaultBanner }

class Banners {
  String id;
  Banners? banners;
  String? url;
  String? startDate;
  String? endDate;
  List<VisibleTo> visibleTo;

  Banners(
      {required this.id,
      required this.visibleTo,
      this.banners,
      this.endDate,
      this.startDate,
      this.url});
}
