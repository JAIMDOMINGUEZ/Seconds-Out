// models/entrenador.

class Entrenador {
  final String? localId;
  final String? remoteId;
  final String nombre;
  final String correo;
  final String? fotoUrl;
  final String fechaNacimiento;
  final String contrasena;
  final String? especialidad;
  final DateTime? ultimaSincronizacion;
  final bool? sincronizado;

  Entrenador({
    this.localId,
    this.remoteId,
    required this.nombre,
    required this.correo,
    this.fotoUrl,
    required this.fechaNacimiento,
    required this.contrasena,
    this.especialidad,
    this.ultimaSincronizacion,
    this.sincronizado,
  });

  Map<String, dynamic> toRemoteMap() {
    return {
      'remoteId': remoteId,
      'nombre': nombre,
      'correo': correo,
      'fotoUrl': fotoUrl,
      'fechaNacimiento': fechaNacimiento,
      'especialidad': especialidad,
      'ultimaSincronizacion': ultimaSincronizacion?.toIso8601String(),
    };
  }

  Entrenador copyWith({
    String? remoteId,
    String? fotoUrl,
    DateTime? ultimaSincronizacion,
    bool? sincronizado,
  }) {
    return Entrenador(
      localId: localId,
      remoteId: remoteId ?? this.remoteId,
      nombre: nombre,
      correo: correo,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fechaNacimiento: fechaNacimiento,
      contrasena: contrasena,
      especialidad: especialidad,
      ultimaSincronizacion: ultimaSincronizacion ?? this.ultimaSincronizacion,
      sincronizado: sincronizado ?? this.sincronizado,
    );
  }
}
