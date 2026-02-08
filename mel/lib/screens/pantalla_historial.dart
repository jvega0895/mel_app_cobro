import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mel/models/ventas.dart';

class PantallaHistorial extends StatelessWidget {
  const PantallaHistorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Hoy'),
        backgroundColor: Colors.orange[200],
      ),
      body: historialVentas.isEmpty
          ? const Center(child: Text('No hay ventas todavía'))
          : ListView.builder(
              itemCount: historialVentas.length,
              itemBuilder: (context, index) {
                final venta = historialVentas[index];
                return ListTile(
                  leading: Icon(
                    venta.tipo == 'Efectivo'
                        ? Icons.money
                        : Icons.account_balance_wallet,
                    color: venta.tipo == 'Efectivo'
                        ? Colors.green
                        : Colors.blue,
                  ),
                  title: Text('\$${venta.monto}'),
                  subtitle: Text(
                    '${venta.tipo} - ${DateFormat('HH:mm').format(venta.fecha)}',
                  ),
                );
              },
            ),
    );
  }
}
