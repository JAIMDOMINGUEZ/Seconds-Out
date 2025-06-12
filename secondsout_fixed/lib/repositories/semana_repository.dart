import 'package:sqflite/sqflite.dart';
import '../data/models/semana.dart';

class SemanaRepository {
  final Database _database;

  SemanaRepository(this._database);

  // Insertar una nueva semana
  Future<Semana> insertarSemana(Semana semana) async {
    try {
      print('Insertando semana: ${semana.toJson()}');
      final id = await _database.insert(
        'semanas',
        semana.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Semana insertada con id: $id');

      // Devuelve una NUEVA instancia de Semana con el ID asignado
      return semana.copyWith(id_semana: id);
    } catch (e) {
      print('Error al insertar semana: $e');
      throw Exception('Error al insertar semana: $e');
    }
  }

  // Obtener todas las semanas de una planeación específica
  Future<List<Semana>> obtenerSemanasPorPlaneacion(int idPlaneacion) async {
    try {
      print('Obteniendo semanas para planeación con id: $idPlaneacion');
      final List<Map<String, dynamic>> maps = await _database.query(
        'semanas',
        where: 'id_planeacion = ?',
        whereArgs: [idPlaneacion],
        orderBy: 'fecha_inicio ASC',
      );

      final semanas = List.generate(maps.length, (i) {
        return Semana.fromJson(maps[i]);
      });

      print('Se encontraron ${semanas.length} semanas');
      return semanas;
    } catch (e) {
      print('Error al obtener semanas: $e');
      throw Exception('Error al obtener semanas: $e');
    }
  }

  // Actualizar una semana existente
  Future<int> actualizarSemana(Semana semana) async {
    try {
      print('Actualizando semana con id ${semana.id_semana}: ${semana.toJson()}');
      final filasAfectadas = await _database.update(
        'semanas',
        semana.toJson(),
        where: 'id_semana = ?',
        whereArgs: [semana.id_semana],
      );
      print('Semanas actualizadas: $filasAfectadas');
      return filasAfectadas;
    } catch (e) {
      print('Error al actualizar semana: $e');
      throw Exception('Error al actualizar semana: $e');
    }
  }

  // Eliminar una semana por su ID
  Future<int> eliminarSemana(int idSemana) async {
    try {
      print('Eliminando sesiones asociadas a semana con id: $idSemana');
      await _database.delete(
        'sesiones',
        where: 'id_semana = ?',
        whereArgs: [idSemana],
      );

      print('Eliminando semana con id: $idSemana');
      final filasEliminadas = await _database.delete(
        'semanas',
        where: 'id_semana = ?',
        whereArgs: [idSemana],
      );
      print('Semanas eliminadas: $filasEliminadas');
      return filasEliminadas;
    } catch (e) {
      print('Error al eliminar semana: $e');
      throw Exception('Error al eliminar semana: $e');
    }
  }

  // Obtener una semana por su ID
  Future<Semana?> obtenerSemanaPorId(int idSemana) async {
    try {
      print('Buscando semana por id: $idSemana');
      final List<Map<String, dynamic>> maps = await _database.query(
        'semanas',
        where: 'id_semana = ?',
        whereArgs: [idSemana],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        final semana = Semana.fromJson(maps.first);
        print('Semana encontrada: ${semana.toJson()}');
        return semana;
      }

      print('No se encontró semana con id: $idSemana');
      return null;
    } catch (e) {
      print('Error al obtener semana por ID: $e');
      throw Exception('Error al obtener semana por ID: $e');
    }
  }
}
