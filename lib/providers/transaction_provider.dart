// Proveedor para gestionar la lista de transacciones
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart' as myModels;

class TransactionProvider with ChangeNotifier {
  List<myModels.Transaction> _transactions = [];

  List<myModels.Transaction> get transactions => _transactions;

  //llamando al metodo fetchTransactions
  TransactionProvider() {
    fetchTransactions();
  }

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
 void addTransaction(String type, String category, double amount, {DateTime? date}) async {
  final newTransaction = myModels.Transaction(
    id: Uuid().v4(), // Genera un ID único
    type: type,
    category: category,
    amount: amount,
    date: date ?? DateTime.now(), // Si no se pasa una fecha, usa la fecha actual
  );
  //Guardando en firestore
  try {
    await FirebaseFirestore.instance.collection('transacciones').doc(newTransaction.id).set({
      'id': newTransaction.id,
      'type': newTransaction.type,
      'category': newTransaction.category,
      'amount': newTransaction.amount,
      'date': newTransaction.date.toIso8601String(), // Guardamos como String ISO8601
    });

  _transactions.add(newTransaction);
  notifyListeners(); // Notifica a los widgets que usan este proveedor
 } catch (e) {
    print('Error al guardar la transacción: $e');
  }
}

  // Método para eliminar una transacción por ID
  void deleteTransaction(String id) async{
   try {
    // Buscar y eliminar el documento en Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection('transacciones')
        .where('id', isEqualTo: id)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Eliminar de la lista local y notificar cambios
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  } catch (e) {
    print('Error al eliminar la transacción: $e');
    }
  }

  //Cargando transacciones desde firestore al inicial el programa
  void fetchTransactions() async {
  try {
    var snapshot = await FirebaseFirestore.instance.collection('transacciones').get();

    _transactions = snapshot.docs.map((doc) {
      var data = doc.data();
      return myModels.Transaction(
        id: data['id'] ?? '', // 🔥 Asegura que siempre haya un ID
        type: data['type'] ?? 'unknown', // 🔥 Evita valores nulos
        category: data['category'] ?? 'Sin categoría',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0, // 🔥 Convierte correctamente
        date: data['date'] != null ? DateTime.parse(data['date']) : DateTime.now(), // 🔥 Maneja nulos
      );
    }).toList();

    notifyListeners();
  } catch (e) {
      print('Error al obtener transacciones: $e');
    }
  }
}

