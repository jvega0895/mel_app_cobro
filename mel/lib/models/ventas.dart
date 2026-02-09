class Venta {
  final double monto;
  final String tipo;
  final DateTime fecha;

  Venta(this.monto, this.tipo, this.fecha);

  // Convierte Venta a JSON (para guardar)
  Map<String, dynamic> toJson() => {
    'monto': monto,
    'tipo': tipo,
    'fecha': fecha.toIso8601String(),
  };

  // Crea una Venta desde JSON (para leer)
  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
    (json['monto'] as num).toDouble(),
    json['tipo'],
    DateTime.parse(json['fecha']),
  );
}

List<Venta> historialVentas = [];
