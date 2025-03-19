import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Para el formato de la fecha
import 'package:cloud_firestore/cloud_firestore.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String? filter = 'category'; // 'category' o 'month'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumen de Gastos')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('transacciones').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          double totalIncome = 0;
          double totalExpense = 0;
          Map<String, double> totalByCategory = {};
          Map<String, double> totalByMonth = {};
          Map<String, List<QueryDocumentSnapshot>> groupedByCategory = {};
          Map<String, List<QueryDocumentSnapshot>> groupedByMonth = {};

          for (var doc in snapshot.data!.docs) {
            var data = doc.data() as Map<String, dynamic>;
            double amount = (data['amount'] as num).toDouble();
            String category = data['category'];
            String type = data['type'];
            DateTime date = (data['date'] as Timestamp).toDate();
            String month = DateFormat('MMMM yyyy').format(date);

            if (type == 'income') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }

            totalByCategory[category] = (totalByCategory[category] ?? 0) + amount;
            totalByMonth[month] = (totalByMonth[month] ?? 0) + amount;

            groupedByCategory.putIfAbsent(category, () => []).add(doc);
            groupedByMonth.putIfAbsent(month, () => []).add(doc);
          }

          return Padding(
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
                      '\$${totalIncome.toStringAsFixed(2)}',
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
                      '\$${totalExpense.toStringAsFixed(2)}',
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
                        totalByCategory.entries.map((entry) {
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
                              if (tx['type'] == 'income') {
                                categoryTotalIncome += tx['amount'];
                              } else {
                                categoryTotalExpense += tx['amount'];
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
                              if (tx['type'] == 'income') {
                                monthTotalIncome += tx['amount'];
                              } else {
                                monthTotalExpense += tx['amount'];
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
          );
        }
      )
    );
  }
}
