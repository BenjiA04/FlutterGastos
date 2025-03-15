// Proveedor para gestionar la lista de transacciones
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Método para calcular el total de ingresos
  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == "income")
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Método para calcular el total de gastos
  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == "expense")
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Método para calcular el total de todas las transacciones
  double get totalAmount {
    return _transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Método para calcular el total por categoría
  Map<String, double> get totalByCategory {
    Map<String, double> categoryTotals = {};
    for (var tx in _transactions) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0.0) + tx.amount;
    }
    return categoryTotals;
  }

  // Método para agregar una nueva transacción
  void addTransaction(String type, String category, double amount) {
    final newTransaction = Transaction(
      id: Uuid().v4(), // Genera un ID único
      type: type,
      category: category,
      amount: amount,
      date: DateTime.now(),
    );
    _transactions.add(newTransaction);
    notifyListeners(); // Notifica a los widgets que usan este proveedor
  }

  // Método para eliminar una transacción por ID
  void deleteTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }
}
