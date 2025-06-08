import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/grupo.dart';

class GrupoRepository {
  final Database db;

  GrupoRepository(this.db);

  Future<int> insertarGrupo(Grupo grupo) async {
    try {
      final map = grupo.toJson();
      map.remove('id_grupo'); // Elimina el ID para autoincremento

      final id = await db.insert(
        'grupos',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Grupo insertado con ID: $id');
      return id;
    } catch (e) {
      debugPrint('Error al insertar grupo: $e');
      throw Exception('Error al insertar grupo: $e');
    }
  }

  Future<bool> eliminarGrupo(int idGrupo) async {
    try {
      final count = await db.delete(
        'grupos',
        where: 'id_grupo = ?',
        whereArgs: [idGrupo],
      );
      debugPrint('Grupos eliminados: $count');
      return count > 0;
    } catch (e) {
      debugPrint('Error al eliminar grupo: $e');
      throw Exception('Error al eliminar grupo: $e');
    }
  }

  Future<List<Grupo>> obtenerTodosLosGrupos() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('grupos');
      debugPrint('Grupos obtenidos: ${maps.length}');
      return maps.map((map) => Grupo.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error al obtener grupos: $e');
      throw Exception('Error al obtener grupos: $e');
    }
  }

  Future<bool> actualizarGrupo(Grupo grupo) async {
    try {
      final count = await db.update(
        'grupos',
        grupo.toJson(),
        where: 'id_grupo = ?',
        whereArgs: [grupo.id_grupo],
      );
      debugPrint('Grupos actualizados: $count');
      return count > 0;
    } catch (e) {
      debugPrint('Error al actualizar grupo: $e');
      throw Exception('Error al actualizar grupo: $e');
    }
  }

  Future<List<Grupo>> buscarGruposPorNombre(String nombre) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'grupos',
        where: 'nombre LIKE ?',
        whereArgs: ['%$nombre%'],
      );
      return maps.map((map) => Grupo.fromJson(map)).toList();
    } catch (e) {
      debugPrint('Error al buscar grupos: $e');
      throw Exception('Error al buscar grupos: $e');
    }
  }
}