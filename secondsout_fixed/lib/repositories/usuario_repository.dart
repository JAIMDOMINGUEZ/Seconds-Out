import 'package:sqflite/sqflite.dart';
import '../data/models/usuario_tipo.dart';
import '/data/models/usuario.dart';


class UsuarioRepository {
  final Database db;

  UsuarioRepository(this.db);

  Future<Usuario?> buscarPorCorreoYContrasena(String correo, String contrasena) async {
    try {
      final usuarios = await db.query(
        'usuarios',
        where: 'correo = ? AND contrasena = ?',
        whereArgs: [correo, contrasena],
        limit: 1,
      );

      if (usuarios.isNotEmpty) {
        return Usuario.fromMap(usuarios.first);
      }
      return null;
    } catch (e) {
      throw Exception('Error buscando usuario: ${e.toString()}');
    }
  }


  Future<UsuarioConTipo> determinarTipoUsuario(int idUsuario) async {
    //print('Buscando tipo para usuario ID: $idUsuario');
    // Verificar administrador
    final admins = await db.rawQuery(
      'SELECT * FROM administradores WHERE id_usuario = ?',
      [idUsuario],
    );
    //print('Resultado admin: $admins');
    if (admins.isNotEmpty) {
      print('Usuario es administrador');
      return UsuarioConTipo(
          admins.first['id_administrador'] as int,
          "admin",
      );
    }

    // Verificar entrenador
    final entrenadores = await db.rawQuery(
      'SELECT * FROM entrenadores WHERE id_usuario = ?',
      [idUsuario],
    );
    //print('Resultado entrenador: $entrenadores');
    if (entrenadores.isNotEmpty) {
      print('Usuario es entrenador');
      return UsuarioConTipo(
          entrenadores.first['id_entrenador'] as int,
          "entrenador",

      );
    }

    // Verificar atleta
    final atletas = await db.rawQuery(
      'SELECT * FROM atletas WHERE id_usuario = ?',
      [idUsuario],
    );
    //print('Resultado atleta: $atletas');
    if (atletas.isNotEmpty) {
      //print('Usuario es atleta');
      return UsuarioConTipo(
          atletas.first['id_atleta'] as int,
          "atleta",

      );
    }

    //print('Usuario no encontrado en ninguna tabla específica');
    return UsuarioConTipo(idUsuario, "no se encontro");
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