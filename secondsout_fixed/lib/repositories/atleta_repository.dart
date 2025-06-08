import 'package:sqflite/sqflite.dart';
import '../data/models/atleta.dart';
import '../data/models/usuario.dart';

class AtletaRepository {
  final Database db;

  AtletaRepository(this.db);

  /// Insertar un nuevo atleta (sin id_atleta para que SQLite lo autogenere)
  Future<int> insertarAtleta(Atleta atleta) async {
    final map = atleta.toMap();
    map.remove('id_atleta');
    return await db.insert('atletas', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Eliminar atleta por su ID
  Future<void> eliminarAtleta(int idAtleta) async {
    await db.delete(
      'atletas',
      where: 'id_atleta = ?',
      whereArgs: [idAtleta],
    );
  }

  /// Actualizar atleta por su ID
  Future<void> actualizarAtleta(Atleta atleta) async {
    await db.update(
      'atletas',
      atleta.toMap(),
      where: 'id_atleta = ?',
      whereArgs: [atleta.idAtleta],
    );
  }

  /// Obtener todos los atletas con datos de usuario asociados
  Future<List<Atleta>> obtenerTodosLosAtletas() async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        a.id_atleta, 
        a.id_usuario, 
        u.nombre, 
        u.correo, 
        u.contrasena, 
        u.fechaNacimiento 
      FROM atletas a
      JOIN usuarios u ON a.id_usuario = u.idUsuario
    ''');
    for (var map in maps) {
      print('--- Atletas ---');
      print('id_atleta: ${map['id_atleta']}');
      print('id_usuario: ${map['id_usuario']}');
      print('nombre: ${map['nombre']}');
      print('correo: ${map['correo']}');
      print('contrasena: ${map['contrasena']}');
      print('fechaNacimiento: ${map['fechaNacimiento']}');
    }
    return List.generate(maps.length, (i) {
      return Atleta(
        idAtleta: maps[i]['id_atleta'],
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

  /// Buscar atletas por nombre
  Future<List<Atleta>> buscarAtletasPorNombre(String nombre) async {
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        a.id_atleta, 
        a.id_usuario, 
        u.nombre, 
        u.correo, 
        u.contrasena, 
        u.fechaNacimiento 
      FROM atletas a
      JOIN usuarios u ON a.id_usuario = u.idUsuario
      WHERE u.nombre LIKE ?
    ''', ['%$nombre%']);

    return List.generate(maps.length, (i) {
      return Atleta(
        idAtleta: maps[i]['id_atleta'],
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
}
