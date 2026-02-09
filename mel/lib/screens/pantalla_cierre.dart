import 'package:flutter/material.dart';
import 'package:mel/models/ventas.dart';
import '../services/storage_service.dart';
import 'pantalla_bienvenida.dart';

class PantallaCierre extends StatelessWidget {
  final double totalEfectivo;
  final double totalTransf;
  final double fondoInicial;
  final double fondoInicialMP;

  const PantallaCierre({
    super.key,
    required this.totalEfectivo,
    required this.totalTransf,
    required this.fondoInicial,
    required this.fondoInicialMP,
  });

  @override
  Widget build(BuildContext context) {
    double netoDelDia = totalEfectivo + totalTransf;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Cierre'),
        backgroundColor: Colors.red[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen Final:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text('Ventas en Efectivo: \$${totalEfectivo.toStringAsFixed(2)}'),
            Text(
              'Ventas por Transferencia: \$${totalTransf.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 10),
            Text(
              'Fondo Inicial Efec: \$${fondoInicial.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Fondo Inicial MP: \$${fondoInicialMP.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(),
            Text(
              'TOTAL GANANCIA HOY: \$${netoDelDia.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'EFECTIVO FINAL (Bolsillo): \$${(fondoInicial + totalEfectivo).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: () async {
                //
                // 1. LIMPIAR LA SESIÓN EN EL ALMACENAMIENTO
                await StorageService.borrarSesion();

                // 2. Limpiar lista temporal
                historialVentas.clear();

                // 3. Volver al inicio reseteando todo el flujo
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaBienvenida(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                'FIN DEL DÍA / CERRAR CAJA',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
