import 'package:flutter/material.dart';
import 'package:mel/models/ventas.dart';
import 'package:mel/services/storage_service.dart';

class PantallaMonto extends StatefulWidget {
  final String tipo;
  const PantallaMonto({super.key, required this.tipo});

  @override
  State<PantallaMonto> createState() => _PantallaMontoState();
}

class _PantallaMontoState extends State<PantallaMonto> {
  // Lista para manejar múltiples productos
  final List<ArticuloVenta> _articulos = [ArticuloVenta()];

  // Controladores para la lógica de efectivo
  final TextEditingController _pagaConController = TextEditingController();
  double _vuelto = 0.0;

  // Cálculo del total de todos los artículos
  double get _totalVenta =>
      _articulos.fold(0, (sum, item) => sum + item.subtotal);

  void _actualizarCalculos() {
    setState(() {
      if (widget.tipo == 'Efectivo') {
        double pagaCon = double.tryParse(_pagaConController.text) ?? 0;
        _vuelto = pagaCon - _totalVenta;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool esEfectivo = widget.tipo == 'Efectivo';

    return Scaffold(
      appBar: AppBar(
        title: Text('Cobro ${widget.tipo}'),
        backgroundColor: esEfectivo ? Colors.green[100] : Colors.blue[100],
      ),
      body: Column(
        children: [
          // 1. LISTA DE ARTÍCULOS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _articulos.length,
              itemBuilder: (context, index) {
                return _buildFilaArticulo(index);
              },
            ),
          ),

          // 2. BOTÓN PARA AGREGAR MÁS ARTÍCULOS
          TextButton.icon(
            onPressed: () => setState(() => _articulos.add(ArticuloVenta())),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Agregar otro artículo'),
          ),

          // 3. RESUMEN Y COBRO
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Fila del Total a Cobrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL A COBRAR:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_totalVenta.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                if (esEfectivo) ...[
                  const SizedBox(height: 15),
                  TextField(
                    controller: _pagaConController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Paga con (Efectivo)',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _actualizarCalculos(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'VUELTO:',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      Text(
                        '\$${_vuelto < 0 ? 0.00 : _vuelto.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 20),

                // BOTÓN FINAL
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _totalVenta > 0 ? () => _finalizarVenta() : null,
                  child: const Text(
                    'TOTALIZAR VENTA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget para cada fila de precio/cantidad
  Widget _buildFilaArticulo(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$',
                ),
                onChanged: (val) {
                  _articulos[index].precio = double.tryParse(val) ?? 0;
                  _actualizarCalculos();
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cant.'),
                onChanged: (val) {
                  _articulos[index].cantidad = int.tryParse(val) ?? 1;
                  _actualizarCalculos();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () {
                if (_articulos.length > 1) {
                  setState(() => _articulos.removeAt(index));
                  _actualizarCalculos();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _finalizarVenta() async {
    historialVentas.add(Venta(_totalVenta, widget.tipo, DateTime.now()));
    await StorageService.guardarVentas(
      historialVentas,
    ); // <--- Guarda permanentemente
    Navigator.pop(context);
  }
}

// Clase auxiliar interna para manejar los datos de la fila
class ArticuloVenta {
  double precio = 0;
  int cantidad = 1;
  double get subtotal => precio * cantidad;
}
