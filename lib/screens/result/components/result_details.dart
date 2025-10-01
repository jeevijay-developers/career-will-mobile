import 'package:flutter/material.dart';
import 'package:careerwill/models/results.dart';
import 'package:fl_chart/fl_chart.dart';

// Small color palette used in this screen for consistency
const Color _cwPrimary = Color(0xFF4F46E5); // indigo-600
const Color _cwAccent = Color(0xFF06B6D4); // teal-400
const Color _cwGold = Color(0xFFF59E0B); // amber-500

class StudentResultDetailScreen extends StatefulWidget {
  final Result result;

  const StudentResultDetailScreen({required this.result, super.key});

  @override
  State<StudentResultDetailScreen> createState() =>
      _StudentResultDetailScreenState();
}

class _StudentResultDetailScreenState extends State<StudentResultDetailScreen> {
  // Cache the subject max values to avoid repeated calculations
  late final Map<String, int> _subjectMaxCache = {};

  // Cache the first rank marks calculation
  late final double _firstRankMarks = _calculateFirstRankMarks();

  // Returns the maximum marks for the given subject name.
  int _subjectMax(String subjectName) {
    return _subjectMaxCache.putIfAbsent(subjectName, () {
      final key = subjectName.toLowerCase();
      if (key.contains('physics') || key.contains('chem')) return 180;
      if (key.contains('biology') || key.contains('bio')) return 360;
      return 100; // default
    });
  }

  double _calculateFirstRankMarks() {
    final double studentMarks = widget.result.total.toDouble();
    double p = widget.result.percentile.toDouble();

    // Handle percentile as fraction (0..1) or percent (0..100)
    if (p <= 1.0) {
      p = p * 100.0;
    }

    // Safety: clamp and avoid division by zero
    if (p <= 0) return studentMarks;
    p = p.clamp(0.0001, 100.0);

    const double topPercent = 100.0; // assume 1st rank got full %
    final estimated = (studentMarks * topPercent) / p;
    return estimated.isFinite ? estimated : studentMarks;
  }

  @override
  Widget build(BuildContext context) {
    String capitalizeFirstLetter(String input) {
      if (input.isEmpty) return input;
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }

    // ✅ Use cached first rank marks calculation
    final firstRankMarks = _firstRankMarks;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(
            capitalizeFirstLetter(widget.result.student),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: true,
          backgroundColor: _cwPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.bar_chart), text: "Performance"),
              Tab(icon: Icon(Icons.leaderboard), text: "Rank & Percentile"),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            children: [
              // ---------------- Tab 1: Performance ----------------
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _infoTile(
                    "👤 Student",
                    capitalizeFirstLetter(widget.result.student),
                  ),
                  _infoTile("👨‍👧 Father", widget.result.father),
                  _infoTile("🆔 Roll No", widget.result.rollNo.toString()),
                  _infoTile("📚 Batch", widget.result.batch),
                  const SizedBox(height: 20),

                  const Divider(thickness: 1.5),
                  Text(
                    "📖 Subject-wise Marks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _cwPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    height: 250,
                    child: _PerformanceGraph(
                      subjects: widget.result.subjects
                          .map((s) => s.name)
                          .toList(),
                      marks: widget.result.subjects
                          .map((s) => s.marks)
                          .toList(),
                      denominators: widget.result.subjects
                          .map((s) => _subjectMax(s.name))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  _highlightTile("📊 Total Marks", "${widget.result.total}"),
                  _highlightTile(
                    "📈 Percentile",
                    "${widget.result.percentile.toStringAsFixed(2)}%",
                  ),
                  const SizedBox(height: 12),
                  // Subject-wise marks display (name — marks/out-of)
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subject-wise Marks',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _cwPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(widget.result.subjects.length, (i) {
                            final name = widget.result.subjects[i].name;
                            final mark = widget.result.subjects[i].marks;
                            final denom = _subjectMax(name);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    '$mark / $denom',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: _cwPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ---------------- Tab 2: Rank & Percentile ----------------
              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    "🏆 Student vs 1st Rank Comparison",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _cwPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: _RankComparisonGraph(
                      studentMarks: widget.result.total.toDouble(),
                      firstRankMarks: firstRankMarks,
                      percentile: widget.result.percentile,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _cwAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Your Marks',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Text(
                            //   '${widget.result.total}',
                            //   style: TextStyle(
                            //     color: _cwAccent,
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: _cwGold,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1st Rank Marks',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _highlightTile("📊 Total Marks", "${widget.result.total}"),
                  _highlightTile("🏅 Rank", "${widget.result.rank}"),
                  _highlightTile(
                    "📈 Percentile",
                    "${widget.result.percentile.toStringAsFixed(2)}%",
                  ),
                  // _highlightTile(
                  //   "🥇 1st Rank Marks",
                  //   firstRankMarks.toStringAsFixed(0),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _cwPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: _cwPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cwPrimary.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _cwPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// 📊 Subject-wise Graph
class _PerformanceGraph extends StatelessWidget {
  final List<String> subjects;
  final List<int> marks;
  final List<int> denominators;
  const _PerformanceGraph({
    required this.subjects,
    required this.marks,
    required this.denominators,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            (denominators.isNotEmpty
                    ? denominators.reduce((a, b) => a > b ? a : b)
                    : 360)
                .toDouble(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < subjects.length) {
                  return RotatedBox(
                    quarterTurns: 0,
                    child: Text(
                      subjects[value.toInt()],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: (denominators.isNotEmpty
                  ? denominators.reduce((a, b) => a > b ? a : b) / 4.0
                  : 90),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(marks.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: marks[i].toDouble(),
                color: _cwPrimary,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// 🏆 Rank Comparison Graph
class _RankComparisonGraph extends StatelessWidget {
  final double studentMarks;
  final double firstRankMarks;
  final num percentile;

  const _RankComparisonGraph({
    required this.studentMarks,
    required this.firstRankMarks,
    required this.percentile,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["Your Marks", "1st Rank"];
    final values = [studentMarks, firstRankMarks];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (() {
          final top =
              (firstRankMarks > studentMarks ? firstRankMarks : studentMarks) +
              20;
          return top < 720 ? 720.0 : top;
        })(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < labels.length) {
                  return Text(
                    labels[value.toInt()],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(values.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                color: i == 0 ? _cwAccent : _cwGold,
                width: 28,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: studentMarks,
              color: _cwAccent.withOpacity(0.6),
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(show: false),
            ),
            HorizontalLine(
              y: firstRankMarks,
              color: _cwGold.withOpacity(0.8),
              strokeWidth: 2,
              dashArray: [5, 5],
              label: HorizontalLineLabel(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
