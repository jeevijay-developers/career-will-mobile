import 'dart:developer';
import 'package:careerwill/models/results.dart';
import 'package:careerwill/models/student.dart';
import 'package:careerwill/service/dio_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final DioService _dio = DioService();

  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];
  final List<Result> _allResults = [];
  List<Result> filteredResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<Student> _parentStudents = [];
  List<Student> get parentStudents => _parentStudents;

  List<Student> get filteredStudents => _filteredStudents;
  List<Student> get allStudents => _allStudents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Student?>> fetchAllStudents() async {
    log(">>> fetchAllStudents called");
    _isLoading = true;
    _errorMessage = null;

    try {
      final response = await _dio.getItems(
        endpointUrl: "/student/get-all-students",
        queryParameters: {"page": 1, "limit": 1000},
      );
      log("status code ---> ${response.statusCode}");
      log(">>> response.data = ${response.data}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data["students"];
        _allStudents = [];
        for (var json in jsonList) {
          try {
            _allStudents.add(Student.fromJson(json));
            log("✅ Student parsed: ${json['_id']}");
          } catch (e) {
            log("❌ Failed to parse student: $e\nData: $json");
          }
        }

        _filteredStudents = _allStudents;
        log("all students ---->   $_allStudents");
      } else {
        _errorMessage = response.data["message"] ?? "Failed to load students.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();

    return _allStudents;
  }

  Future<void> searchStudent(String query) async {
    if (query.isEmpty) {
      _filteredStudents = _allStudents;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: '/student/search-students',
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        _filteredStudents = data.map((json) => Student.fromJson(json)).toList();
      } else {
        _filteredStudents = [];
        _errorMessage = "Failed to search students.";
      }
    } catch (e) {
      _filteredStudents = [];
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchResult(String query) async {
    log("Starting search for: $query");

    if (query.isEmpty) {
      filteredResults = _allResults;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: '/test-score/search-test-scores',
        queryParameters: {'query': query},
      );

      log("Status: ${response.statusCode}");
      log("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        final List data = response.data;
        log("Raw List Length: ${data.length}");

        filteredResults = data.map((json) {
          log("Parsing result: ${json['student']}");
          return Result.fromJson(json);
        }).toList();

        log("Parsed filteredResults length: ${filteredResults.length}");
        _errorMessage = null;
      } else {
        filteredResults = [];
        _errorMessage = "Failed to search result.";
      }
    } catch (e) {
      filteredResults = [];
      _errorMessage = e.toString();
      log("Error during result search: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Student?> fetchStudentById(String id) async {
    log("🔍 fetchStudentById called with ID: $id");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _dio.getItems(
        endpointUrl: "/student/get-student-by-id/$id",
      );

      log("📡 Status: ${response.statusCode}");
      log("📡 Data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final student = Student.fromJson(response.data);
        log("✅ Student parsed: ${student.id}");

        // 👉 Add to parent-specific list without replacing entire DB
        if (!_parentStudents.any((s) => s.id == student.id)) {
          _parentStudents.add(student);
        }

        _isLoading = false;
        notifyListeners();
        return student;
      } else {
        _errorMessage = "Failed to fetch student with id $id.";
      }
    } catch (e, st) {
      log("❌ Error fetching student: $e\n$st");
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  void clearSearchResult() {
    filteredResults = [];
    notifyListeners();
  }
}
