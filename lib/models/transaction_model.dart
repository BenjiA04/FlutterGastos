// Modelo de datos para representar una transacción
class Transaction {
  String id;
  String type; // "income" (ingreso) o "expense" (gasto)
  String category;
  double amount;
  DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
  });
}
