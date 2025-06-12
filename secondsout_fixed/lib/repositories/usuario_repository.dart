import 'package:sqflite/sqflite.dart';
import '/data/models/usuario.dart';
import '/data/models/usuario_login.dart';

class UsuarioRepository {
  final Database db;

  UsuarioRepository(this.db);

  Future<UsuarioLogin?> login(String correo, String contrasena) async {
    try {
      // Validación básica
      if (correo.isEmpty || contrasena.isEmpty) {
        throw Exception('Correo y contraseña son requeridos');
      }

      // Buscar usuario
      final usuarios = await db.query(
        'usuarios',
        where: 'correo = ? AND contrasena = ?',
        whereArgs: [correo, contrasena],
        limit: 1,
      );

      if (usuarios.isEmpty) return null;

      final usuario = Usuario.fromMap(usuarios.first);
      final tipoUsuario = await _determinarTipoUsuario(usuario.idUsuario);

      return UsuarioLogin(usuario: usuario, tipoUsuario: tipoUsuario);
    } catch (e) {
      throw Exception('Error en login: ${e.toString()}');
    }
  }

  Future<TipoUsuario> _determinarTipoUsuario(int idUsuario) async {
    // Verificar administrador
    final admins = await db.query(
      'administradores',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      limit: 1,
    );
    if (admins.isNotEmpty) return TipoUsuario.administrador;

    // Verificar entrenador
    final entrenadores = await db.query(
      'entrenadores',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      limit: 1,
    );
    if (entrenadores.isNotEmpty) return TipoUsuario.entrenador;

    // Verificar atleta
    final atletas = await db.query(
      'atletas',
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
      limit: 1,
    );
    if (atletas.isNotEmpty) return TipoUsuario.atleta;

    return TipoUsuario.desconocido;
  }

  Future<int> insertarUsuario(Usuario usuario) async {
    try {
      final map = usuario.toMap();
      map.remove('idUsuario');

      return await db.insert(
        'usuarios',
        map,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      throw Exception('Error al insertar usuario: ${e.toString()}');
    }
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'idUsuario = ?',
      whereArgs: [usuario.idUsuario],
    );
  }

  Future<Usuario?> obtenerUsuarioPorId(int idUsuario) async {
    final maps = await db.query(
      'usuarios',
      where: 'idUsuario = ?',
      whereArgs: [idUsuario],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }
}