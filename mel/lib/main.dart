import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Importante
import 'package:mel/models/ventas.dart';
import 'screens/pantalla_bienvenida.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cargamos las ventas guardadas antes de arrancar la app
  historialVentas = await StorageService.cargarVentas();
  runApp(const AppFeria());
}

class AppFeria extends StatelessWidget {
  const AppFeria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Feria',
      // CONFIGURACIÓN DE IDIOMA ESPAÑOL
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'AR'), // Español de Argentina (o solo 'es')
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const PantallaBienvenida(),
    );
  }
}
