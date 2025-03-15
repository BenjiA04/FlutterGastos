# Gestor de Gastos Personales
Este es un gestor de gastos desarrollado en Flutter con Dart. La aplicación permite a los usuarios registrar sus ingresos y gastos, organizarlos por categoría y visualizar un resumen detallado de sus finanzas. Está construido con Flutter, lo que permite su funcionamiento en múltiples plataformas como Android e iOS.

## Descripcion
El Gestor de Gastos Personales está diseñado para ayudar a los usuarios a llevar un control eficiente de sus finanzas, registrando sus ingresos y gastos de manera ordenada. La aplicación ofrece una interfaz intuitiva con listas estilizadas y permite visualizar el total acumulado, así como un desglose por categorías.

## Estructura del Proyecto

#### 1. main.dart
- Punto de entrada de la aplicación → Configura el ChangeNotifierProvider y establece la pantalla principal.
#### 2. models
- transaction_model.dart → Define la estructura de una transacción (ingreso o gasto) con atributos como ID, categoría, monto y tipo.
#### 3. providers
- transaction_provider.dart → Gestiona el estado de las transacciones, incluyendo la suma total, el cálculo por categorías y la funcionalidad de agregar o eliminar transacciones.
#### 4. screens
- home_screen.dart → Pantalla principal donde se muestran las transacciones en una lista organizada, con opción de agregar y eliminar elementos.
- add_transaction_screen.dart → Pantalla donde los usuarios pueden ingresar nuevos gastos o ingresos, seleccionando categoría y monto.
- summary_screen.dart → Pantalla de resumen que muestra el total de ingresos, gastos y el desglose por categoría en listas estilizadas.

### Getting Started
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
