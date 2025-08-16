import 'dart:developer';

import 'package:careerwill/models/user.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:careerwill/utitlity/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserProvider extends ChangeNotifier {
  DioService dio = DioService();
  final box = GetStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  String? _tempPhone;
  String? _tempJobId;
  String? _tempMessageId;

  String? get tempPhone => _tempPhone;
  String? get tempJobId => _tempJobId;
  String? get tempMessageId => _tempMessageId;

  Future<bool> login({required String email, password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.postItems(
        endpointUrl: "/auth/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        _message = response.data["message"];
        var userJson = response.data["user"];
        User loginUser = User.fromJson(userJson);

        await saveLoginInfo(loginUser);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _message = "Login failed: ${response.data}";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> saveLoginInfo(User? loginUser) async {
    await box.write(USER_INFO_BOX, loginUser?.toJson());
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = box.read(USER_INFO_BOX);
    return User.fromJson(userJson!);
  }

  Future<void> logout() async {
    await box.erase();
    _message = null;
    _isLoading = false;
    notifyListeners();

    log("User logged out");
  }

  Future<bool> parentLogin({required num mobileNumber}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.postItems(
        endpointUrl: "/auth/parent-login",
        data: {"mobileNumber": mobileNumber.toString()},
      );

      if (kDebugMode) log("Response: ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        _message = response.data["message"];
        // Store mobile number, jobId, or messageId if needed for OTP screen
        _tempPhone = mobileNumber.toString();
        _tempJobId = response.data["jobId"];
        _tempMessageId = response.data["messageId"];

        _isLoading = false;
        return true;
      } else {
        _message = response.data["message"] ?? "Login failed";
      }
    } catch (e) {
      _message = "Exception: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> verifyParentOTP({required String otpCode}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await dio.postItems(
        endpointUrl: "/auth/verify-login-otp",
        data: {"mobileNumber": _tempPhone, "code": otpCode},
      );

      if (kDebugMode) log("OTP Verify Response: ${response.data}");

      if (response.statusCode == 200) {
        _message = response.data["message"];

        final students = response.data['data'];
        if (students is List && students.isNotEmpty) {
          // ✅ collect all student IDs
          final studentIds = students.map((e) => e["_id"].toString()).toList();

          // ✅ pick parent details from first student
          final parentName = students[0]['parent']?['fatherName'] ?? "Parent";

          final user = User.fromJson({
            "_id":
                response.data["_id"] ??
                "", // parent id if API sends, else empty
            "email": "", // parent login is by phone, so keep empty
            "role": "parent",
            "token": response.data["token"] ?? "",
            "username": parentName,
            "phone": _tempPhone,
            "students": studentIds, // ✅ all student IDs linked
          });

          await saveLoginInfo(user);
          log("✅ Saved user: ${user.toJson()}");

          _isLoading = false;
          return true;
        } else {
          _message = "No student data found.";
        }
      } else {
        _message = response.data["message"] ?? "OTP verification failed.";
      }
    } catch (e) {
      _message = "Exception during OTP verification: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // For test phone shortcut
  void setTestPhone(String phone) {
    _tempPhone = phone;
  }

  // Fake login for test case
  Future<void> fakeTestLogin() async {
    final user = User(
      id: "test-id",
      email: "test@example.com",
      role: "parent",
      token: "test-token",
      username: "John Doe",
      phone: _tempPhone!,
      students: [], // No students in test
    );
    await saveLoginInfo(user);
  }
}
