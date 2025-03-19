// Punto de entrada de la aplicación
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_proyectofinal/firebase_options.dart';
import 'package:provider/provider.dart';
// import 'models/transaction_model.dart';
import 'providers/transaction_provider.dart';
import 'screens/home_screen.dart';
// import 'screens/add_transaction_screen.dart';
// import 'screens/summary_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TransactionProvider(), // Proveedor para la gestión del estado de las transacciones
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestor de Gastos',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(), // Establece la pantalla principal de la app
      ),
    );
  }
}
