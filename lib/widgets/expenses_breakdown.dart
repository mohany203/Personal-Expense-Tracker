import 'package:flutter/material.dart';
import 'package:personal_expenses/extensions/string_extensions.dart';
import 'package:personal_expenses/models/expense.dart';

class ExpensesBreakdown extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensesBreakdown({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final totalAmount = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    final groupedData =
        expenses.groupBy((e) => e.category).entries.map((entry) {
      final categoryTotal = entry.value.fold<double>(
        0.0,
        (sum, expense) => sum + expense.amount,
      );
      final percentage = totalAmount > 0
          ? (categoryTotal / totalAmount * 100).toStringAsFixed(1)
          : '0';

      return {
        'category': entry.key,
        'total': categoryTotal,
        'percentage': percentage,
        'date':
            entry.value.isNotEmpty ? entry.value.first.date : DateTime.now(),
      };
    }).toList();

    groupedData.sort((a, b) => b['total'].compareTo(a['total']));

    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        final data = groupedData[index];
        final category = data['category'] as Category;
        final total = data['total'] as double;
        final percentage = data['percentage'] as String;
        final date = data['date'] as DateTime;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${category.toString().split('.').last.capitalize()}: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Percentage: $percentage%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${date.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
