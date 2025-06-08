import 'usuario.dart';
/*
class Administrador extends Usuario {
  Administrador({
    int? localId,
    String? remoteId,
    required String nombre,
    required String correo,
    required String contrasena,
    String? fotoUrl,
    required String fechaNacimiento,
    required DateTime ultimaSincronizacion,
    required bool sincronizado,
  }) : super(
    localId: localId,
    remoteId: remoteId,
    nombre: nombre,
    correo: correo,
    contrasena: contrasena,
    fotoUrl: fotoUrl,
    fechaNacimiento: fechaNacimiento,
    ultimaSincronizacion: ultimaSincronizacion,
    sincronizado: sincronizado,
  );

  factory Administrador.fromJson(Map<String, dynamic> json) => Administrador(
    localId: json['localId'],
    remoteId: json['remoteId'],
    nombre: json['nombre'],
    correo: json['correo'],
    contrasena: json['contrasena'],
    fotoUrl: json['fotoUrl'],
    fechaNacimiento: json['fechaNacimiento'],
    ultimaSincronizacion: DateTime.parse(json['ultimaSincronizacion']),
    sincronizado: json['sincronizado'],
  );

  Map<String, dynamic> toJson() => {
    'localId': localId,
    'remoteId': remoteId,
    'nombre': nombre,
    'correo': correo,
    'contrasena': contrasena,
    'fotoUrl': fotoUrl,
    'fechaNacimiento': fechaNacimiento,
    'ultimaSincronizacion': ultimaSincronizacion.toIso8601String(),
    'sincronizado': sincronizado ? 1 : 0,



  @override
  Map<String, dynamic> toRemoteMap() {
    // TODO: implement toRemoteMap
    throw UnimplementedError();
  }incronizado,
    'tipo': 'administrador',
  };

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
*/