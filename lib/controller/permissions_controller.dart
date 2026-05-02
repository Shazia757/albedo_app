import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

class PermissionsController extends GetxController {
  final permissions = <String, bool>{}.obs;

  final box = GetStorage();
  final String storageKey = "permissions";

  @override
  void onInit() {
    super.onInit();
    loadPermissions();
  }

  /// 🔹 LOAD FROM STORAGE
  void loadPermissions() {
    final stored = box.read(storageKey);

    if (stored != null) {
      permissions.assignAll(Map<String, bool>.from(stored));
    }
  }

  /// 🔹 SAVE TO STORAGE
  void savePermissions() {
    box.write(storageKey, permissions);
  }

  /// 🔹 TOGGLE + SAVE
  void toggle(String key, bool value) {
    permissions[key] = value;
    savePermissions(); // 🔥 important
  }

  bool get(String key) => permissions[key] ?? false;

  /// optional: initialize defaults (only if empty)
  void initDefaults(List<String> keys) {
    if (permissions.isEmpty) {
      for (final key in keys) {
        permissions[key] = false;
      }
      savePermissions();
    }
  }
}

class PermissionService {
  static bool can(String key) {
    final c = Get.find<PermissionsController>();
    return c.permissions[key] ?? false;
  }
}

class P {
  static bool can(String key) => PermissionService.can(key);

  static bool get showStudents => can("show_students");
  static bool get showTeachers => can("show_teachers");
  static bool get showMentors => can("show_mentors");
}

class PermissionGuard extends StatelessWidget {
  final String permission;
  final Widget child;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!PermissionService.can(permission)) {
      return const SizedBox.shrink();
    }
    return child;
  }
}
