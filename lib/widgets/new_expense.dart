import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.transportation;

  final formatter = DateFormat("dd MMM yyyy");
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final double? enteredAmount = double.tryParse(_amountController.text);
    final bool amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill out all fields'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      dev.log(_titleController.text);
      dev.log(_amountController.text);
      dev.log(_selectedDate.toString());

      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Expense",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.abc),
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  filled: true,
                  fillColor:
                      theme.colorScheme.primaryContainer.withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: DropdownButtonFormField(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            Icon(
                              categoryIcons[e],
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              e.name[0].toUpperCase() + e.name.substring(1),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (newCategory) {
                  setState(() {
                    if (newCategory == null) {
                      return;
                    }
                    _selectedCategory = newCategory;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Category",
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                  fillColor:
                      theme.colorScheme.primaryContainer.withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          prefixText: "\$ ",
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: theme.colorScheme.primaryContainer
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextButton.icon(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate =
                              DateTime(now.year - 5, now.month, now.day);
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: firstDate,
                            lastDate: now,
                          );

                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        },
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          _selectedDate == null
                              ? "Pick a Date"
                              : formatter.format(_selectedDate!),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: theme.colorScheme.primaryContainer
                              .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final double? enteredAmount =
                          double.tryParse(_amountController.text);
                      if (enteredAmount != null && _selectedDate != null) {
                        widget.onAddExpense(
                          Expense(
                            category: _selectedCategory,
                            title: _titleController.text,
                            amount: enteredAmount,
                            date: _selectedDate!,
                          ),
                        );
                        _saveExpense();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Please fill out all fields correctly'),
                            backgroundColor:
                                theme.colorScheme.error.withOpacity(0.8),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "Save Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
