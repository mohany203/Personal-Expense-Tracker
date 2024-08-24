import 'package:flutter/material.dart';
import 'package:personal_expenses/chart/chart.dart';
import 'package:personal_expenses/extensions/string_extensions.dart';
import 'package:personal_expenses/models/expense.dart';
import 'package:personal_expenses/widgets/new_expense.dart';
import 'package:personal_expenses/widgets/expenses_list.dart';
import 'package:personal_expenses/widgets/expenses_breakdown.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> with TickerProviderStateMixin {
  final List<Expense> _registeredExpenses = [
    Expense(
      category: Category.entertainment,
      title: 'Cinema',
      amount: 9.71,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.food,
      title: 'Breakfast',
      amount: 31.3,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.travel,
      title: 'Flight Ticket',
      amount: 199.0,
      date: DateTime(2024, 8, 30),
    ),
    Expense(
      category: Category.personalCare,
      title: 'Haircut',
      amount: 25.0,
      date: DateTime(2024, 8, 17),
    ),
    Expense(
      category: Category.utilities,
      title: 'Electricity Bill',
      amount: 40,
      date: DateTime(2024, 7, 30),
    ),
    Expense(
      category: Category.health,
      title: 'Doctor Appointment',
      amount: 50.0,
      date: DateTime(2024, 8, 10),
    ),
  ];

  int _selectedIndex = 0;
  Category? _selectedCategory;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _iconController.forward(from: 0.0).then((_) => _iconController.reverse());
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void _filterByCategory(Category? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  double get _totalAmount {
    return _registeredExpenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses =
        _selectedCategory == null || _selectedCategory == Category.all
            ? _registeredExpenses
            : _registeredExpenses
                .where((expense) => expense.category == _selectedCategory)
                .toList();

    final sortedExpenses = List<Expense>.from(filteredExpenses)
      ..sort((a, b) => b.date.compareTo(a.date));

    final List<Widget> pages = [
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF61efa1),
                    Color(0xFF2ed8b6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Here's your expense overview:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: EnhancedChart(
                            expenses: sortedExpenses,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Expenses',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${_totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<Category>(
                    value: _selectedCategory,
                    hint: const Text('Select Category'),
                    onChanged: (Category? newValue) {
                      _filterByCategory(newValue);
                    },
                    items: [
                      const DropdownMenuItem<Category>(
                        value: Category.all,
                        child: Text('All Categories'),
                      ),
                      ...Category.values
                          .where((category) => category != Category.all)
                          .map(
                        (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(
                              category.toString().split('.').last.capitalize(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: sortedExpenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses added yet.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ExpensesList(
                      expenses: sortedExpenses,
                      onRemoveExpense: _removeExpense,
                    ),
            ),
          ],
        ),
      ),
      ExpensesBreakdown(expenses: sortedExpenses),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_name.png',
              height: 30,
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => NewExpense(onAddExpense: _addExpense),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Breakdown',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
      ),
    );
  }
}
