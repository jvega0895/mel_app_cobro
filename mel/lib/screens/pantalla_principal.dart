import 'package:flutter/material.dart';
import 'package:mel/models/ventas.dart';
import 'pantalla_monto.dart';
import 'pantalla_historial.dart';
import 'pantalla_cierre.dart';

class PantallaPrincipal extends StatefulWidget {
  final String nombre;
  final double fondoInicial;
  final double fondoInicialMP;

  const PantallaPrincipal({
    super.key,
    required this.nombre,
    required this.fondoInicial,
    required this.fondoInicialMP,
  });

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  double get totalEfectivoVentas => historialVentas
      .where((v) => v.tipo == 'Efectivo')
      .fold(0, (prev, v) => prev + v.monto);

  double get totalTransferencia => historialVentas
      .where((v) => v.tipo == 'Transferencia')
      .fold(0, (prev, v) => prev + v.monto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caja: ${widget.nombre}'),
        backgroundColor: Colors.green[200],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildColumnaSaldo(
                  "Efectivo en Mano",
                  widget.fondoInicial + totalEfectivoVentas,
                  Colors.green,
                ),
                _buildColumnaSaldo(
                  "Saldo Mercado Pago",
                  widget.fondoInicialMP + totalTransferencia,
                  Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          ListTile(
            leading: const Icon(Icons.money, color: Colors.green, size: 30),
            title: const Text('Cobrar en EFECTIVO'),
            subtitle: const Text('Suma al fondo físico'),
            onTap: () => _irACobro(context, 'Efectivo'),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
              size: 30,
            ),
            title: const Text('Cobrar con MERCADO PAGO'),
            subtitle: const Text('Suma al saldo virtual'),
            onTap: () => _irACobro(context, 'Transferencia'),
          ),

          const Divider(height: 30),

          ListTile(
            leading: const Icon(Icons.history, color: Colors.orange),
            title: const Text('VER HISTORIAL DEL DÍA'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PantallaHistorial(),
                ),
              );
              setState(() {});
            },
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // CORRECCIÓN AQUÍ: Ahora pasamos los 4 parámetros que PantallaCierre necesita
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaCierre(
                      totalEfectivo: totalEfectivoVentas,
                      totalTransf: totalTransferencia,
                      fondoInicial: widget.fondoInicial,
                      fondoInicialMP:
                          widget.fondoInicialMP, // <--- ESTO FALTABA
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.lock_clock, color: Colors.white),
              label: const Text(
                'CERRAR DÍA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnaSaldo(String titulo, double monto, Color color) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(
          '\$${monto.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  void _irACobro(BuildContext context, String tipo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PantallaMonto(tipo: tipo)),
    );
    setState(() {});
  }
}
