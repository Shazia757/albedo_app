import 'dart:convert';
import 'dart:developer';

import 'package:albedo_app/config/urls.dart';
import 'package:albedo_app/config/utils.dart';
import 'package:albedo_app/database/local_storage.dart';
import 'package:albedo_app/model/users/user_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<String?> refreshAccessToken() async {
    final refreshToken = LocalStorage().readRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await http.post(
        Uri.parse(Urls.refreshToken),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refresh": refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newAccess = data["access"];
        final newRefresh = data["refresh"];

        await LocalStorage().writeToken(newAccess, newRefresh);

        return newAccess;
      }
    } catch (e) {
      log("Refresh error: $e");
    }

    return null;
  }

  Future<http.Response> safeRequest(
    Future<http.Response> Function(Map<String, String> headers) request,
  ) async {
    String? accessToken = LocalStorage().readAccessToken();

    // first request
    http.Response response = await request(getHeader(accessToken));

    // if expired → refresh
    if (response.statusCode == 401) {
      accessToken = await refreshAccessToken();

      if (accessToken != null) {
        response = await request(getHeader(accessToken));
      }
    }

    return response;
  }

  //------------------Login---------------------------//

  Future<dynamic> login(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.login),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during login: $e');
    }

    return null;
  }

//------------------Google Login---------------------------//

  Future<dynamic> googleLogin(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.googleLogin),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();

      log('Api error during google login: $e');
    }

    return null;
  }
  //------------------Forgot password---------------------------//

  Future<dynamic> forgotPasswordRequest(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordRequest),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during forgot password request: $e');
    }

    return null;
  }

  Future<dynamic> validateForgotPasswordToken(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordValidate),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during token validation: $e');
    }

    return null;
  }

  Future<dynamic> forgotPasswordConfirm(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.forgotPasswordConfirm),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during password reset confirm: $e');
    }

    return null;
  }

//------------------Reset password---------------------------//

  Future<dynamic> passwordResetRequest(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.passwordReset),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseJson["message"];
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during password reset request: $e');
    }

    return null;
  }

  Future<dynamic> resetPasswordConfirm(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse(Urls.resetPasswordConfirm),
            headers: getHeader(),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during reset password confirm: $e');
    }

    return null;
  }
//------------------User Details---------------------------//

  Future<dynamic> userDetails() async {
    try {
      final response = await http
          .get(
            Uri.parse(Urls.userDetails),
            headers: getHeader(),
          )
          .timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200) {
        return Users.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();

      log('Api error during user details: $e');
    }

    return null;
  }

//------------------Update User---------------------------//

  Future<dynamic> updateUser(String id, Map<String, dynamic> data) async {
    try {
      final response = await safeRequest((headers) {
        return http.put(
          Uri.parse(Urls.editUserById(id)),
          headers: headers,
          body: jsonEncode(data),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Users.fromJson(responseJson);
      }

      // ERROR
      return parseError(responseJson);
    } catch (e) {
      checkConnectivity();
      log('Api error during updateUser: $e');
    }

    return null;
  }

  //------------------Logout---------------------------//

  Future<bool> logout() async {
    try {
      final response = await safeRequest((headers) {
        return http.post(
          Uri.parse(Urls.logout),
          headers: headers,
          body: jsonEncode({}),
        );
      }).timeout(const Duration(seconds: 60));

      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE BODY: ${response.body}");

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      // SUCCESS
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      // ERROR
      log(parseError(responseJson).toString());
    } catch (e) {
      checkConnectivity();
      log('Api error during logout: $e');
    }

    return false;
  }
  //------------------Change Password---------------------------//

  // Future<GeneralResponse?> changePassword(Map<String, dynamic> data) async {
  //   try {
  //     final response = await http
  //         .post(Uri.parse(Urls.changePassword),
  //             body: jsonEncode(data), headers: await getHeader())
  //         .timeout(Duration(seconds: 60));

  //     if (checkValidations(response.body)) {
  //       final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
  //       return GeneralResponse.fromJson(responseJson);
  //     }
  //   } catch (e) {
  //     checkConnectivity();
  //     log('Api error:$e');
  //   }
  //   return null;
  // }

  //------------------Reset Password---------------------------//

  // Future<GeneralResponse?> resetPassword(Map<String, dynamic> data) async {
  //   try {
  //     final response = await http
  //         .post(Uri.parse(Urls.resetPassword),
  //             body: jsonEncode(data), headers: await getHeader())
  //         .timeout(Duration(seconds: 60));

  //     if (checkValidations(response.body)) {
  //       final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
  //       return GeneralResponse.fromJson(responseJson);
  //     }
  //   } catch (e) {
  //     checkConnectivity();
  //     log('Api error:$e');
  //   }
  //   return null;
  // }
}
