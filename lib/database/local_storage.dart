import 'dart:developer';

import 'package:albedo_app/model/users/user_model.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final _box = GetStorage();

  writeUser(Users user) {
    try {
      _box.write('user', user.toJson());
      _box.write('isLoggedIn', true);
      print("SAVED USER: ${_box.read('user')}");
    } catch (e) {
      log(e.toString());
    }
  }

  writeToken(String toc) {
    try {
      _box.write('token', toc);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> readToken() async {
    try {
      final token = await _box.read('token');
      return token;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void writePermissions(String userId, Map<String, bool> permissions) {
    try {
      _box.write('permissions_$userId', permissions);
    } catch (e) {
      log(e.toString());
    }
  }

  Map<String, bool>? readPermissions(String userId) {
    try {
      final data = _box.read('permissions_$userId');
      if (data == null) return null;

      return Map<String, bool>.from(data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static bool get isAdmin {
    final data = GetStorage().read('user');
    if (data == null) return false;

    return data['role'] == 'admin';
  }

  Users? readUser() {
    try {
      final data = _box.read('user');
      print("RAW DATA FROM STORAGE: $data");
      if (data == null) return null;

      return Users.fromJson(data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  clearAll() {
    _box.erase();
  }
}
