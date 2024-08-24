import 'package:flutter/material.dart';
import 'package:personal_expenses/models/expense.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense) onRemoveExpense;

  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return Dismissible(
          key: ValueKey(expense.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            onRemoveExpense(expense);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${expense.title} removed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              ),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(categoryIcons[expense.category]),
              title: Text(expense.title),
              subtitle: Text(expense.formattedDate()),
              trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
            ),
          ),
        );
      },
    );
  }
}
