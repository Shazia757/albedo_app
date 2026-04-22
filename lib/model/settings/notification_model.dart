import 'package:albedo_app/controller/settings_controller.dart';

class Notifications {
  String id;
  String? title;
  String? message;
  List<VisibleTo> visibleTo;
  bool isImportant;

  Notifications(
      {required this.id,
      this.message,
      this.title,
      required this.visibleTo,
      this.isImportant = false});
}
