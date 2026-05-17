import 'package:albedo_app/database/local_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    // Get.to(() => NoInternetScreen());
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
