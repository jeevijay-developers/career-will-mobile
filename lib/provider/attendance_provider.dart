import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:careerwill/models/attendance.dart'; // We'll define this next

class AttendanceProvider extends ChangeNotifier {
  final DioService _dio = DioService();

  List<Attendance> _attendanceList = [];
  List<Attendance> get attendanceList => _attendanceList;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAttendanceByRollNo(String rollNo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: '/student/get-attendence-by-rollnumber/$rollNo',
      );

      log("Attendance response: ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        _attendanceList = data.map((json) => Attendance.fromJson(json)).toList();
      } else {
        _attendanceList = [];
        _errorMessage = "Failed to load attendance data.";
      }
    } catch (e) {
      _attendanceList = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearAttendance() {
    _attendanceList = [];
    notifyListeners();
  }
}
