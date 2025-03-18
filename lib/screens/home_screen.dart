import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'add_transaction_screen.dart';
import 'summary_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestor de Gastos')),
      body: StreamBuilder(
        // Escucha los cambios en la colección "transacciones"
        stream: FirebaseFirestore.instance.collection('transacciones').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay transacciones aún'));
          }

          // Procesa los datos de Firestore
          double totalIncome = 0.0;
          double totalExpense = 0.0;
          List transactions = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            if (data['type'] == 'income') {
              totalIncome += data['amount'];
            } else {
              totalExpense += data['amount'];
            }
            return data;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${(totalIncome - totalExpense).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                SizedBox(height: 20),

                // Gráfico de barras con los totales de ingresos y gastos
                SizedBox(
                  height: 200, // Ajusta la altura según necesites
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: totalIncome,  // Ingresos
                              color: Colors.green,
                              width: 20,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: totalExpense, // Gastos
                              color: Colors.red,
                              width: 20,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          tx['type'] == "income" ? Colors.green : Colors.red,
                      child: Icon(
                        tx['type'] == "income"
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      tx['category'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      tx['type'] == "income" ? "Ingreso" : "Gasto",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${tx['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('transacciones')
                                    .doc(tx['id'])
                                    .delete();
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
            );
          }
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
