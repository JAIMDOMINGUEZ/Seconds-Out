import 'package:sqflite/sqflite.dart';
import '../data/models/planeacion.dart';

class PlaneacionRepository {
  final Database db;

  PlaneacionRepository(this.db);

  Future<int> insertarPlaneacion(Planeacion planeacion) async {
    final map = planeacion.toJson();
    map.remove('id_planeacion');
    print('Insertando planeacion: $map');
    final result = await db.insert('planeaciones', map, conflictAlgorithm: ConflictAlgorithm.replace);
    print('Planeacion insertada con id: $result');
    return result;
  }

  Future<void> eliminarPlaneacion(int idPlaneacion) async {
    print('Eliminando planeacion con id: $idPlaneacion');
    await db.delete(
      'planeaciones',
      where: 'id_planeacion = ?',
      whereArgs: [idPlaneacion],
    );
    print('Planeacion eliminada con id: $idPlaneacion');
  }

  Future<void> actualizarPlaneacion(Planeacion planeacion) async {
    print('Actualizando planeacion con id: ${planeacion.id_planeacion}');
    await db.update(
      'planeaciones',
      planeacion.toJson(),
      where: 'id_planeacion = ?',
      whereArgs: [planeacion.id_planeacion],
    );
    print('Planeacion actualizada con id: ${planeacion.id_planeacion}');
  }

  Future<List<Planeacion>> obtenerTodasLasPlaneaciones() async {
    print('Obteniendo todas las planeaciones');
    final maps = await db.query('planeaciones');
    for (var map in maps) {
      print('nombre: ${map['nombre']}');
      print('fecha_inicio: ${map['fecha_inicio']}');
      print('fecha_fin: ${map['fecha_fin']}');

    }


    return List.generate(maps.length, (i) {
      return Planeacion.fromJson(maps[i]);
    });
  }

  Future<List<Planeacion>> buscarPlaneacionesPorNombre(String nombre) async {
    print('Buscando planeaciones con nombre similar a: $nombre');
    final maps = await db.query(
      'planeaciones',
      where: 'nombre LIKE ?',
      whereArgs: ['%$nombre%'],
    );
    print('Planeaciones encontradas: ${maps.length}');
    return List.generate(maps.length, (i) {
      return Planeacion.fromJson(maps[i]);
    });
  }
}
