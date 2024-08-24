import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dateTime = DateFormat('dd MMM yyyy');

enum Category {
  all,
  food,
  rent,
  utilities,
  transportation,
  entertainment,
  health,
  diningOut,
  shopping,
  education,
  travel,
  personalCare,
  subscriptions,
  debt,
  savings,
  donations,
  miscellaneous,
}

const categoryIcons = {
  Category.all: Icons.select_all,
  Category.food: Icons.lunch_dining,
  Category.rent: Icons.home,
  Category.utilities: Icons.flash_on,
  Category.transportation: Icons.directions_car,
  Category.entertainment: Icons.movie,
  Category.health: Icons.local_hospital,
  Category.diningOut: Icons.restaurant,
  Category.shopping: Icons.shopping_bag,
  Category.education: Icons.school,
  Category.travel: Icons.flight,
  Category.personalCare: Icons.spa,
  Category.subscriptions: Icons.subscriptions,
  Category.debt: Icons.attach_money,
  Category.savings: Icons.savings,
  Category.donations: Icons.volunteer_activism,
  Category.miscellaneous: Icons.category,
};

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String formattedDate() {
    return dateTime.format(date);
  }

  Expense({
    required this.category,
    required this.title,
    required this.amount,
    required this.date,
  }) : id = uuid.v4();
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket(this.category, this.expenses);
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (var expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
