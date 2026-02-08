import 'dart:convert';
import 'package:mel/models/ventas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _key = 'historial_completo';

  // Guarda la lista de ventas actual en el teléfono
  static Future<void> guardarVentas(List<Venta> lista) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      lista.map((venta) => venta.toJson()).toList(),
    );
    await prefs.setString(_key, encodedData);
  }

  // Carga todas las ventas guardadas
  static Future<List<Venta>> cargarVentas() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_key);

    if (encodedData == null) return [];

    final List<dynamic> decodedData = jsonDecode(encodedData);
    return decodedData.map((item) => Venta.fromJson(item)).toList();
  }

  // Borra todo el historial del teléfono
  static Future<void> borrarTodo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // Guarda los datos de la sesión actual
  static Future<void> guardarSesion(
    String nombre,
    double fondo,
    double fondoMP,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sesion_nombre', nombre);
    await prefs.setDouble('sesion_fondo', fondo);
    await prefs.setDouble('sesion_fondoMP', fondoMP);
    await prefs.setBool('sesion_activa', true);
  }

  // Borra la sesión al cerrar el día
  static Future<void> borrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sesion_nombre');
    await prefs.remove('sesion_fondo');
    await prefs.remove('sesion_fondoMP');
    await prefs.setBool('sesion_activa', false);
  }

  // Recupera los datos de la sesión
  static Future<Map<String, dynamic>?> cargarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('sesion_activa') != true) return null;
    return {
      'nombre': prefs.getString('sesion_nombre'),
      'fondo': prefs.getDouble('sesion_fondo'),
      'fondoMP': prefs.getDouble('sesion_fondoMP'),
    };
  }
}
