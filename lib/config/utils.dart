import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/view/no_connection_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

bool checkValidations(String response) {
  if (response.contains('Invalid token')) {
    // Get.offAll(() => TokenExpiredScreen());
    return false;
  } else if (response.contains('updation required') ||
      response.contains('Unsupported OS or app version.')) {
    // Get.offAll(() => AppUpdateScreen(status: false));

    return false;
  }
  return true;
}

checkConnectivity() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult.contains(ConnectivityResult.none)) {
    Get.to(() => NoInternetScreen());
  }
}

Map<String, String> getHeader([String? token]) {
  final accessToken = token ?? LocalStorage().readAccessToken();

  return {
    "Content-Type": "application/json",
    "Accept": "application/json",
    if (accessToken != null && accessToken.isNotEmpty)
      "Authorization": "Bearer $accessToken",
  };
}

String parseError(Map<String, dynamic> json) {
  /// Handle direct detail/message
  if (json['detail'] != null) {
    return json['detail'].toString();
  }

  if (json['message'] != null) {
    return json['message'].toString();
  }

  /// Handle nested errors object
  if (json['errors'] is Map) {
    final errors = json['errors'] as Map<String, dynamic>;

    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }

      if (value is String) {
        return value;
      }
    }
  }

  /// Handle top-level lists
  for (final value in json.values) {
    if (value is List && value.isNotEmpty) {
      return value.first.toString();
    }

    if (value is String) {
      return value;
    }
  }

  return 'Something went wrong';
}

Duration? parseDuration(dynamic value) {
  if (value == null) return null;

  final parts = value.toString().split(':');

  if (parts.length != 3) return null;

  return Duration(
    hours: int.tryParse(parts[0]) ?? 0,
    minutes: int.tryParse(parts[1]) ?? 0,
    seconds: int.tryParse(parts[2]) ?? 0,
  );
}

TimeOfDay? parseTimeOfDay(String? time) {
  if (time == null || time.isEmpty) return null;

  try {
    final format = DateFormat("hh:mm a");
    final dateTime = format.parse(time);

    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  } catch (_) {
    return null;
  }
}

TimeOfDay? parse24TimeOfDay(String? time) {
  if (time == null || time.isEmpty) return null;

  try {
    final dateTime = DateFormat("HH:mm:ss").parse(time);

    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  } catch (_) {
    return null;
  }
}

double? parseDouble(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}