abstract class Usuario {
  final int? localId; // Para SQLite
  final String? remoteId; // Para Firebase
  final String nombre;
  final String correo;
  final String? fotoUrl;
  final String fechaNacimiento;
  final String contrasena;
  final DateTime ultimaSincronizacion;
  final bool sincronizado;

  Usuario({
    this.localId,
    this.remoteId,
    required this.nombre,
    required this.correo,
    this.fotoUrl,
    required this.fechaNacimiento,
    required this.contrasena,
    required this.ultimaSincronizacion,
    required this.sincronizado,
  });

  Map<String, dynamic> toLocalMap();
  Map<String, dynamic> toRemoteMap();
}