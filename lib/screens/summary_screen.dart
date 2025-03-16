import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';  // Para el formato de la fecha
import '../models/transaction_model.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String? filter = 'category'; // 'category' o 'month'

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Agrupar por mes
    Map<String, List<Transaction>> groupedByMonth = {};
    for (var tx in transactionProvider.transactions) {
      String month = DateFormat('MMMM yyyy').format(tx.date);  // Formato: Enero 2025
      if (groupedByMonth[month] == null) {
        groupedByMonth[month] = [];
      }
      groupedByMonth[month]!.add(tx);
    }

    // Agrupar por categoría
    Map<String, List<Transaction>> groupedByCategory = {};
    for (var tx in transactionProvider.transactions) {
      if (groupedByCategory[tx.category] == null) {
        groupedByCategory[tx.category] = [];
      }
      groupedByCategory[tx.category]!.add(tx);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Resumen de Gastos')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muestra el total de ingresos
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  'Total Ingresos',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                trailing: Text(
                  '\$${transactionProvider.totalIncome.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Muestra el total de gastos
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(
                  'Total Gastos',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                trailing: Text(
                  '\$${transactionProvider.totalExpense.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Muestra el total por categoría
            Text(
              'Total por Categoría:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children:
                    transactionProvider.totalByCategory.entries.map((entry) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(entry.key,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('\$${entry.value.toStringAsFixed(2)}'),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Filtro para ver transacciones por categoría o por mes
            Text(
              'Filtrar por:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: filter,
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'category',
                  child: Text('Por Categoría'),
                ),
                DropdownMenuItem<String>(
                  value: 'month',
                  child: Text('Por Mes'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Mostrar total por mes o por categoría según el filtro seleccionado
            Text(
              filter == 'category' ? 'Total por Categoría:' : 'Total por Mes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: filter == 'category'
                    ? groupedByCategory.entries.map((entry) {
                        double categoryTotalIncome = 0;
                        double categoryTotalExpense = 0;

                        for (var tx in entry.value) {
                          if (tx.type == 'income') {
                            categoryTotalIncome += tx.amount;
                          } else {
                            categoryTotalExpense += tx.amount;
                          }
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(entry.key,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Ingresos: \$${categoryTotalIncome.toStringAsFixed(2)}, Gastos: \$${categoryTotalExpense.toStringAsFixed(2)}'),
                          ),
                        );
                      }).toList()
                    : groupedByMonth.entries.map((entry) {
                        double monthTotalIncome = 0;
                        double monthTotalExpense = 0;

                        for (var tx in entry.value) {
                          if (tx.type == 'income') {
                            monthTotalIncome += tx.amount;
                          } else {
                            monthTotalExpense += tx.amount;
                          }
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            title: Text(entry.key,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Ingresos: \$${monthTotalIncome.toStringAsFixed(2)}, Gastos: \$${monthTotalExpense.toStringAsFixed(2)}'),
                          ),
                        );
                      }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
