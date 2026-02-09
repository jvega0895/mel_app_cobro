import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mel/models/ventas.dart';
import '../services/storage_service.dart';
import 'pantalla_principal.dart';

class PantallaBienvenida extends StatefulWidget {
  const PantallaBienvenida({super.key});

  @override
  State<PantallaBienvenida> createState() => _PantallaBienvenidaState();
}

class _PantallaBienvenidaState extends State<PantallaBienvenida> {
  final TextEditingController _controllerNombre = TextEditingController();
  final TextEditingController _controllerFondo = TextEditingController();
  final TextEditingController _controllerFondoMP = TextEditingController();

  List<Venta> _todoElHistorial = [];
  bool _haySesionActiva = false;
  Map<String, dynamic>? _datosSesion;

  @override
  void initState() {
    super.initState();
    _inicializarApp();
  }

  Future<void> _inicializarApp() async {
    final ventas = await StorageService.cargarVentas();
    final sesion = await StorageService.cargarSesion();

    setState(() {
      _todoElHistorial = ventas;
      historialVentas = ventas;
      if (sesion != null) {
        _haySesionActiva = true;
        _datosSesion = sesion;
      } else {
        _haySesionActiva = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mel! Tu app de cobro.'),
          centerTitle: true,
          backgroundColor: Colors.green[100],
          bottom: const TabBar(
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            tabs: [
              Tab(icon: Icon(Icons.store), text: 'CAJA'),
              Tab(icon: Icon(Icons.history), text: 'HISTORIAL'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildSeccionCaja(), _buildVistaHistorialAgrupado()],
        ),
      ),
    );
  }

  Widget _buildSeccionCaja() {
    return _haySesionActiva
        ? _buildVistaSesionActiva()
        : _buildFormularioInicio();
  }

  Widget _buildVistaSesionActiva() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_open, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          const Text(
            "SESIÓN EN CURSO",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text("Cajero: ${_datosSesion!['nombre']}"),
              subtitle: Text(
                "Fondo: \$${_datosSesion!['fondo']} | MP: \$${_datosSesion!['fondoMP']}",
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaPrincipal(
                    nombre: _datosSesion!['nombre'],
                    fondoInicial: _datosSesion!['fondo'],
                    fondoInicialMP: _datosSesion!['fondoMP'],
                    fechaApertura:
                        _datosSesion!['fechaApertura'] ??
                        DateTime.now(), // Enviamos la fecha guardada
                  ),
                ),
              );
              _inicializarApp();
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            label: const Text(
              "CONTINUAR VENDIENDO",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Para iniciar una nueva caja con otros montos, primero debes 'Cerrar Día' dentro de la caja actual.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFormularioInicio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          const Icon(Icons.storefront, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          TextField(
            controller: _controllerNombre,
            decoration: const InputDecoration(
              labelText: 'Nombre del Cajero',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _controllerFondo,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Efectivo Inicial',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _controllerFondoMP,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saldo inicial Mercado Pago',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 55),
            ),
            onPressed: () async {
              String nombre = _controllerNombre.text.isEmpty
                  ? "Cajero"
                  : _controllerNombre.text;
              double fondo = double.tryParse(_controllerFondo.text) ?? 0.0;
              double fondoMP = double.tryParse(_controllerFondoMP.text) ?? 0.0;

              // CAPTURAMOS LA FECHA DE ESTE MOMENTO
              DateTime ahora = DateTime.now();

              // GUARDAMOS CON LA FECHA DE APERTURA
              await StorageService.guardarSesion(nombre, fondo, fondoMP, ahora);

              if (context.mounted) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaPrincipal(
                      nombre: nombre,
                      fondoInicial: fondo,
                      fondoInicialMP: fondoMP,
                      fechaApertura: ahora,
                    ),
                  ),
                );
                _inicializarApp();
              }
            },
            child: const Text(
              'ABRIR NUEVA CAJA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HISTORIAL Y BORRADO  ---
  Widget _buildVistaHistorialAgrupado() {
    if (_todoElHistorial.isEmpty) {
      return const Center(child: Text('Aún no tienes ventas registradas.'));
    }

    Map<String, List<Venta>> porMes = {};
    for (var v in _todoElHistorial) {
      String mesKey = DateFormat(
        'MMMM yyyy',
        'es',
      ).format(v.fecha).toUpperCase();
      porMes.putIfAbsent(mesKey, () => []).add(v);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _confirmarBorrado(),
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.delete_forever, color: Colors.white),
        label: const Text(
          'BORRAR HISTORIAL',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: porMes.keys.length,
        itemBuilder: (context, index) {
          String mesAnio = porMes.keys.elementAt(index);
          List<Venta> ventasDelMes = porMes[mesAnio]!;
          double totalMes = ventasDelMes.fold(
            0,
            (sum, item) => sum + item.monto,
          );

          return ExpansionTile(
            title: Text(
              mesAnio,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Total Mes: \$${totalMes.toStringAsFixed(2)}'),
            children: _buildDiasDelMes(ventasDelMes),
          );
        },
      ),
    );
  }

  List<Widget> _buildDiasDelMes(List<Venta> ventas) {
    Map<String, List<Venta>> porDia = {};
    for (var v in ventas) {
      String diaKey = DateFormat('EEEE dd/MM', 'es').format(v.fecha);
      porDia.putIfAbsent(diaKey, () => []).add(v);
    }
    return porDia.entries.map((entry) {
      double totalDia = entry.value.fold(0, (sum, item) => sum + item.monto);
      return Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: ExpansionTile(
          title: Text(entry.key),
          trailing: Text(
            '\$${totalDia.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          children: entry.value
              .map(
                (v) => ListTile(
                  dense: true,
                  title: Text('${v.tipo}: \$${v.monto.toStringAsFixed(2)}'),
                  subtitle: Text(
                    'Hora: ${DateFormat('HH:mm').format(v.fecha)}',
                  ),
                ),
              )
              .toList(),
        ),
      );
    }).toList();
  }

  void _confirmarBorrado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Borrar historial?'),
        content: const Text('Se eliminarán todas las ventas pasadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.borrarTodo();
              _inicializarApp();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('BORRAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
