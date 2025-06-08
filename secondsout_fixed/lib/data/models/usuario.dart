class Usuario {
  final int idUsuario;
  final String nombre;
  final String correo;
  final String contrasena;
  final String fechaNacimiento;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.fechaNacimiento,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'fechaNacimiento': fechaNacimiento,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUsuario: map['idUsuario'],
      nombre: map['nombre'],
      correo: map['correo'],
      contrasena: map['contrasena'],
      fechaNacimiento: map['fechaNacimiento'],
    );
  }
}