import 'package:get/get.dart';

class PermissionsController extends GetxController {
  /// stores all permission states
  final permissions = <String, bool>{}.obs;

  /// toggle permission
  void toggle(String key, bool value) {
    permissions[key] = value;
  }

  bool get(String key) => permissions[key] ?? false;

  /// optional: initialize defaults
  void initDefaults(List<String> keys) {
    for (final key in keys) {
      permissions.putIfAbsent(key, () => false);
    }
  }
}