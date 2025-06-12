import 'package:sqflite/sqflite.dart';
import '/data/models/ejercicio_asignado.dart';

class EjercicioAsignadoRepository {
  final Database _database;

  EjercicioAsignadoRepository(this._database);

  // Create
  Future<int> insertEjercicioAsignado(EjercicioAsignado ejercicio) async {
    return await _database.insert(
      'ejercicio_asignado',
      ejercicio.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<List<EjercicioAsignado>> getEjerciciosBySesion(int idSesion) async {
    final ejercicios = await _database.rawQuery('''
    SELECT ea.*, e.nombre 
    FROM ejercicio_asignado ea
    JOIN ejercicios e ON ea.id_ejercicio = e.id_ejercicio
    WHERE ea.id_sesion = ?
    ORDER BY ea.id_ejercicio_asignado
  ''', [idSesion]);

    print('_________________________');
    for (var ejercicio in ejercicios) {
      print('Ejercicio: ${ejercicio['id_ejercicio_asignado']}');
      print('Nombre: ${ejercicio['nombre']}'); // Ahora sí debería aparecer
      print('Repeticiones: ${ejercicio['repeticiones']}');
      print('Tiempo de trabajo: ${ejercicio['tiempoTrabajo']}');
      print('Tiempo de descanso: ${ejercicio['tiempoDescanso']}');
    }
    return ejercicios.map((e) => EjercicioAsignado.fromJson(e)).toList();
  }

  // Update
  Future<int> updateEjercicioAsignado(EjercicioAsignado ejercicio) async {
    return await _database.update(
      'ejercicio_asignado',
      ejercicio.toJson(),
      where: 'id_ejercicio_asignado = ?',
      whereArgs: [ejercicio.id_ejercicio_asignado],
    );
  }

  // Delete
  Future<int> deleteEjercicioAsignado(int id) async {
    return await _database.delete(
      'ejercicio_asignado',
      where: 'id_ejercicio_asignado = ?',
      whereArgs: [id],
    );
  }

  // Delete all ejercicios from a sesion
  Future<int> deleteEjerciciosBySesion(int idSesion) async {
    return await _database.delete(
      'ejercicio_asignado',
      where: 'id_sesion = ?',
      whereArgs: [idSesion],
    );
  }
}