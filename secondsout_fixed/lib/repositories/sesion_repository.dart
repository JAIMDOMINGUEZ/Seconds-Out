import 'package:sqflite/sqflite.dart';
import '/data/models/sesion.dart';

class SesionRepository {
  final Database db;

  SesionRepository(this.db);

  Future<int> insertarSesion(Sesion sesion) async {
    return await db.insert('sesiones', sesion.toJson());
  }

  Future<List<Sesion>> obtenerSesionesPorSemana(int idSemana) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'sesiones',
      where: 'id_semana = ?',
      whereArgs: [idSemana],
    );
    /*
    print('_________________________');
    for(var map in maps){
      print('id sesion: ${map['id_sesion']}');
      print('nombre: ${map['nombre']}');

    }*/

    return maps.map((map) => Sesion.fromJson(map)).toList();
  }

  Future<int> actualizarSesion(Sesion sesion) async {
    return await db.update(
      'sesiones',
      sesion.toJson(),
      where: 'id_sesion = ?',
      whereArgs: [sesion.id_sesion],
    );
  }

  Future<int> eliminarSesion(int idSesion) async {
    return await db.delete(
      'sesiones',
      where: 'id_sesion = ?',
      whereArgs: [idSesion],
    );
  }
}
