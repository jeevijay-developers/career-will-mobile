import 'package:careerwill/models/attendance.dart';
import 'package:careerwill/models/student.dart';
import 'package:careerwill/provider/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceScreen extends StatefulWidget {
  final Student student;

  const AttendanceScreen({super.key, required this.student});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _focusedDay.month;
    _selectedYear = _focusedDay.year;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AttendanceProvider()
            ..fetchAttendanceByRollNo(widget.student.rollNo.toString()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          title: Text(
            "${widget.student.name}'s Attendance",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
        ),
        body: Consumer<AttendanceProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            final attendanceMap = {
              for (var att in provider.attendanceList)
                DateUtils.dateOnly(att.date): att.presentStatus,
            };

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildMonthYearSelector(),
                  Card(
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2024, 1, 1),
                        lastDay: DateTime.now(),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay.isAfter(DateTime.now())) return;
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.deepPurple.shade600,
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                          defaultTextStyle: const TextStyle(
                            color: Colors.black87,
                          ),
                          outsideDaysVisible: false,
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, _) {
                            final status =
                                attendanceMap[DateUtils.dateOnly(day)];
                            if (status == 'P') {
                              return _buildDayCell(day, Colors.green);
                            } else if (status == 'A') {
                              return _buildDayCell(day, Colors.red);
                            }
                            return null;
                          },
                          todayBuilder: (context, day, _) =>
                              _buildDayCell(day, Colors.blue.shade400),
                          selectedBuilder: (context, day, _) =>
                              _buildDayCell(day, Colors.deepPurple.shade600),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedDay != null)
                    _buildSelectedDayDetails(
                      provider.attendanceList,
                      _selectedDay!,
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(DateTime day, Color color) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetails(List<Attendance> list, DateTime selectedDay) {
    final record = list.firstWhere(
      (att) => DateUtils.dateOnly(att.date) == DateUtils.dateOnly(selectedDay),
      orElse: () => Attendance(
        id: '',
        rollNo: '',
        name: '',
        inTime: 'N/A',
        outTime: 'N/A',
        lateArrival: 'N/A',
        earlyDeparture: 'N/A',
        workingHours: 'N/A',
        otDuration: 'N/A',
        presentStatus: 'Absent',
        date: selectedDay,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, dd MMM yyyy').format(record.date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _infoRow(
                "Status",
                record.presentStatus == 'P' ? '✅ Present' : '❌ Absent',
              ),
              const Divider(),
              _infoRow("In Time", record.inTime),
              _infoRow("Out Time", record.outTime),
              _infoRow("Late Arrival", record.lateArrival),
              _infoRow("Early Departure", record.earlyDeparture),
              _infoRow("Working Hours", record.workingHours),
              _infoRow("OT Duration", record.otDuration),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearSelector() {
    List<int> years = List.generate(
      DateTime.now().year - 2023 + 1,
      (index) => 2023 + index,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: _dropdownDecoration("Month"),
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                );
              }),
              onChanged: (value) {
                final newDate = DateTime(_selectedYear, value!);
                if (newDate.isAfter(DateTime.now())) {
                  _showFutureDateDialog();
                  return;
                }
                setState(() {
                  _selectedMonth = value;
                  _focusedDay = newDate;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: _dropdownDecoration("Year"),
              items: years
                  .map(
                    (year) =>
                        DropdownMenuItem(value: year, child: Text('$year')),
                  )
                  .toList(),
              onChanged: (value) {
                final newDate = DateTime(value!, _selectedMonth);
                if (newDate.isAfter(DateTime.now())) {
                  _showFutureDateDialog();
                  return;
                }
                setState(() {
                  _selectedYear = value;
                  _focusedDay = newDate;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  void _showFutureDateDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Invalid Selection"),
        content: const Text("🚫 Future dates cannot be selected."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
