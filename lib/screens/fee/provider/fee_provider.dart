import 'dart:developer';
import 'package:careerwill/models/feeModel.dart';
import 'package:flutter/material.dart';
import 'package:careerwill/service/dio_service.dart';

class FeeProvider extends ChangeNotifier {
  final DioService _dio = DioService();

  FeeModel? _fee;
  bool _isLoading = false;
  String? _errorMessage;

  FeeModel? get fee => _fee;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFeeByRollNo(int rollNo) async {
    log("🔍 fetchFeeByRollNo called with: $rollNo");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: "/fee/get-fee-by-roll-number/$rollNo",
      );

      log("📡 Status Code: ${response.statusCode}");
      log("📡 Response Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> feeList = data['fees'] ?? [];

        if (feeList.isNotEmpty) {
          _fee = FeeModel.fromJson(feeList[0]);
          log("✅ Fee parsed for rollNo $rollNo");
        } else {
          _fee = null;
          _errorMessage = "No fee records found for this roll number.";
          log("⚠️ No fee records found for rollNo $rollNo");
        }
      } else {
        _fee = null;
        _errorMessage = "Fee data not found.";
        log("❌ Fee data not found for rollNo $rollNo");
      }
    } catch (e) {
      _fee = null;
      _errorMessage = e.toString();
      log("💥 Error fetching fee: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearFee() {
    _fee = null;
    notifyListeners();
  }
}
