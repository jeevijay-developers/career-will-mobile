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

  Future<void> fetchFeeByRollNumber(int rollNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: "/fee/get-fee-by-roll-number/$rollNumber",
      );

      log("📦 Fee response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> feeList = response.data;

        if (feeList.isNotEmpty) {
          _fee = FeeModel.fromJson(feeList[0]); // ✅ Correct usage
        } else {
          _fee = null;
          _errorMessage = "No fee records found for this roll number.";
        }
      } else {
        _fee = null;
        _errorMessage = "Fee data not found.";
      }
    } catch (e) {
      log("❌ Fee fetch error: $e");
      _fee = null;
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
