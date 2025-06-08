import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/usuario.dart';


class UsuarioRepository {
  final Database db;

  UsuarioRepository(this.db);

  Future<int> insertarUsuario(Usuario usuario) async {
    try {
      final map = usuario.toMap();
      map.remove('idUsuario'); // Permite que la BD asigne el ID

      return await db.insert(
        'usuarios',
        map,
        conflictAlgorithm: ConflictAlgorithm.fail, // Cambiado a fail para detectar duplicados
      );
    } catch (e) {
      debugPrint('Error al insertar usuario: $e');
      rethrow;
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