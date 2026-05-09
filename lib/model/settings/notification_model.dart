import 'package:albedo_app/controller/settings_controller.dart';

class Notifications {
  String id;
  String? title;
  String? message;
  List<VisibleTo> visibleTo;
  bool isImportant;
  DateTime? date;

  Notifications(
      {required this.id,
      this.message,
      this.title,
      required this.visibleTo,
      this.date,
      this.isImportant = false});
}
