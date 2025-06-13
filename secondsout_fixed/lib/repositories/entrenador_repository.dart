import 'package:sqflite/sqflite.dart';
import '/data/models/entrenador.dart';
import '/data/models/usuario.dart';

class EntrenadorRepository {
  final Database db;

  EntrenadorRepository(this.db);

  Future<int> insertarEntrenador(Entrenador entrenador) async {
    // Elimina el id_entrenador del mapa para que SQLite auto-genere el ID
    final map = entrenador.toMap();
    map.remove('id_entrenador'); // Esto permite que la base de datos asigne el ID automáticamente

    return await db.insert(
      'entrenadores',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> eliminarEntrenador(int idEntrenador) async {
    await db.delete(
      'entrenadores',
      where: 'id_entrenador = ?',
      whereArgs: [idEntrenador],
    );
  }

  Future<List<Entrenador>> obtenerTodosLosEntrenadores() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        e.id_entrenador, 
        e.id_usuario, 
        u.nombre, 
        u.correo, 
        u.contrasena, 
        u.fechaNacimiento 
      FROM entrenadores e
      JOIN usuarios u ON e.id_usuario = u.idUsuario
    ''');/*
    for (var map in maps) {
      print('--- Entrenador ---');
      print('id_entrenador: ${map['id_entrenador']}');
      print('id_usuario: ${map['id_usuario']}');
      print('nombre: ${map['nombre']}');
      print('correo: ${map['correo']}');
      print('contrasena: ${map['contrasena']}');
      print('fechaNacimiento: ${map['fechaNacimiento']}');
    }*/

    return List.generate(maps.length, (i) {
      return Entrenador(
        idEntrenador: maps[i]['id_entrenador'],
        idUsuario: maps[i]['id_usuario'],
        usuario: Usuario(
          idUsuario: maps[i]['id_usuario'],
          nombre: maps[i]['nombre'],
          correo: maps[i]['correo'],
          contrasena: maps[i]['contrasena'],
          fechaNacimiento: maps[i]['fechaNacimiento'],
        ),
      );
    });
  }

  Future<List<Entrenador>> buscarEntrenadoresPorNombre(String nombre) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT e.id_entrenador, e.id_usuario, u.nombre, u.correo, u.contrasena, u.fechaNacimiento 
      FROM entrenadores e
      JOIN usuarios u ON e.id_usuario = u.idUsuario
      WHERE u.nombre LIKE ?
    ''', ['%$nombre%']);

    return List.generate(maps.length, (i) {
      return Entrenador(
        idEntrenador: maps[i]['id_entrenador'],
        idUsuario: maps[i]['id_usuario'],
        localId: maps[i]['id_entrenador'], // Asignar el id_entrenador a localId
        usuario: Usuario(
          idUsuario: maps[i]['id_usuario'],
          nombre: maps[i]['nombre'],
          correo: maps[i]['correo'],
          contrasena: maps[i]['contrasena'],
          fechaNacimiento: maps[i]['fechaNacimiento'],
        ),
      );
    });
  }

}
