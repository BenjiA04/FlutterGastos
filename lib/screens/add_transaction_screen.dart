// Pantalla para agregar una nueva transacción
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = "expense"; // Tipo predeterminado: gasto
  String _category = "General"; // Categoría predeterminada
  double _amount = 0.0;
  DateTime? _selectedDate; // Variable para almacenar la fecha seleccionada

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Transacción')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Selector de tipo de transacción
              DropdownButtonFormField(
                value: _type,
                items: [
                  DropdownMenuItem(value: "income", child: Text("Ingreso")),
                  DropdownMenuItem(value: "expense", child: Text("Gasto")),
                ],
                onChanged: (value) => setState(() => _type = value.toString()),
              ),
              // Campo de entrada para la categoría
              TextFormField(
                decoration: InputDecoration(labelText: "Categoría"),
                onChanged: (value) => _category = value,
              ),
              // Campo de entrada para el monto
              TextFormField(
                decoration: InputDecoration(labelText: "Monto"),
                keyboardType: TextInputType.number,
                onChanged: (value) => _amount = double.tryParse(value) ?? 0.0,
              ),
              // Selector de fecha
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? "Selecciona la fecha"
                        : "${_selectedDate!.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botón para agregar la transacción
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Agregar la transacción con la fecha seleccionada
                    Provider.of<TransactionProvider>(context, listen: false)
                        .addTransaction(_type, _category, _amount, date: _selectedDate);
                    Navigator.pop(context); // Regresa a la pantalla anterior
                  }
                },
                child: Text("Agregar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
