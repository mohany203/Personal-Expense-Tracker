import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_expenses/models/expense.dart';

class EnhancedChart extends StatelessWidget {
  final List<Expense> expenses;

  const EnhancedChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final totalAmount = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    if (totalAmount == 0) {
      return const Center(
        child: Text('No expenses to display.'),
      );
    }

    final groupedData = expenses.groupBy((e) => e.category).entries.map((entry) {
      final categoryTotal = entry.value.fold<double>(
        0.0,
        (sum, expense) => sum + expense.amount,
      );
      final percentage = (categoryTotal / totalAmount * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: categoryTotal,
        title: '$percentage%',
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: groupedData,
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

Color _getCategoryColor(Category category) {
  switch (category) {
    case Category.food:
      return Colors.red;
    case Category.rent:
      return Colors.blueAccent;
    case Category.utilities:
      return Colors.purple;
    case Category.transportation:
      return Colors.teal;
    case Category.entertainment:
      return Colors.orange;
    case Category.health:
      return Colors.green;
    case Category.diningOut:
      return Colors.pink;
    case Category.shopping:
      return Colors.amber;
    case Category.education:
      return Colors.indigo;
    case Category.travel:
      return Colors.cyan;
    case Category.personalCare:
      return Colors.deepOrange;
    case Category.subscriptions:
      return Colors.lime;
    case Category.debt:
      return Colors.brown;
    case Category.savings:
      return Colors.grey;
    case Category.donations:
      return Colors.lightBlue;
    case Category.miscellaneous:
      return Colors.deepPurple;
    case Category.all:
    default:
      return Colors.grey[600]!;
  }
}
}

extension GroupBy<K, V> on Iterable<V> {
  Map<K, List<V>> groupBy(K Function(V) key) {
    final Map<K, List<V>> map = {};
    for (final value in this) {
      final k = key(value);
      if (!map.containsKey(k)) {
        map[k] = [];
      }
      map[k]!.add(value);
    }
    return map;
  }
}
