import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import '/data/models/ejercicio.dart';

class EjercicioRepository {
  final Database db;

  EjercicioRepository(this.db);

  Future<int> insertarEjercicio(Ejercicio ejercicio) async {
    final map = ejercicio.toJson();
    map.remove('id_ejercicio'); // Elimina el ID para autoincremento

    return await db.insert(
      'ejercicios',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> eliminarEjercicio(int idEjercicio) async {
    try {
      final count = await db.delete(
        'ejercicios',
        where: 'id_ejercicio = ?', // Asegúrate que coincida con tu esquema de BD
        whereArgs: [idEjercicio],
      );

      // Retorna true si se eliminó al menos un registro
      return count > 0;
    } catch (e) {
      throw Exception('Error al eliminar ejercicio: $e');
    }
  }

  Future<List<Ejercicio>> obtenerTodosLosEjercicios() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query('ejercicios');
      for (var map in maps) {
        print('--- Ejercicios ---');
        print('id_ejercicio: ${map['id_ejercicio']}');
        print('nombre: ${map['nombre']}');

      }
      return maps.map((map) => Ejercicio.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Error al obtener ejercicios: $e');
    }
  }

  Future<List<Ejercicio>> buscarEjerciciosPorNombre(String nombre) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'ejercicios',
        where: 'nombre LIKE ?',
        whereArgs: ['%$nombre%'],
      );
      return maps.map((map) => Ejercicio.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Error al buscar ejercicios: $e');
    }
  }

  Future<bool> actualizarEjercicio(Ejercicio ejercicio) async {
    try {
      debugPrint('Actualizando ejercicio con ID: ${ejercicio.id_ejercicio}');
      debugPrint('Datos a actualizar: ${ejercicio.toJson()}');

      final count = await db.update(
        'ejercicios',
        ejercicio.toJson(),
        where: 'id_ejercicio = ?',
        whereArgs: [ejercicio.id_ejercicio],
      );

      debugPrint('Filas actualizadas: $count');
      return count > 0;
    } catch (e) {
      debugPrint('Error al actualizar ejercicio: $e');
      throw Exception('Error al actualizar ejercicio: $e');
    }
  }
}