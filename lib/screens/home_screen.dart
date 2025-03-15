// Pantalla principal que muestra la lista de transacciones con diseño mejorado
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Gestor de Gastos')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Muestra el total de transacciones (suma de ingresos y gastos)
                Text(
                  'Total: \$${transactionProvider.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Botón para navegar a la pantalla de resumen de gastos
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SummaryScreen()),
                    );
                  },
                  child: Text("Ver Resumen"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                final tx = transactionProvider
                    .transactions[index]; // Obtiene cada transacción
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          tx.type == "income" ? Colors.green : Colors.red,
                      child: Icon(
                        tx.type == "income"
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      tx.category,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tx.type == "income" ? "Ingreso" : "Gasto",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${tx.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            transactionProvider.deleteTransaction(
                                tx.id); // Elimina la transacción seleccionada
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Botón flotante para agregar nuevas transacciones
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
