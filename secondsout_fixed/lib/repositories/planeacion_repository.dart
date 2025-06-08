import 'package:sqflite/sqflite.dart';
import '../data/models/planeacion.dart';

class PlaneacionRepository {
  final Database db;

  PlaneacionRepository(this.db);

  Future<int> insertarPlaneacion(Planeacion planeacion) async {
    final map = planeacion.toJson();
    map.remove('id_planeacion');
    return await db.insert('planeaciones', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> eliminarPlaneacion(int idPlaneacion) async {
    await db.delete(
      'planeaciones',
      where: 'id_planeacion = ?',
      whereArgs: [idPlaneacion],
    );
  }

  Future<void> actualizarPlaneacion(Planeacion planeacion) async {
    await db.update(
      'planeaciones',
      planeacion.toJson(),
      where: 'id_planeacion = ?',
      whereArgs: [planeacion.id_planeacion],
    );
  }

  Future<List<Planeacion>> obtenerTodasLasPlaneaciones() async {
    final maps = await db.query('planeaciones');

    return List.generate(maps.length, (i) {
      return Planeacion.fromJson(maps[i]);
    });
  }

  Future<List<Planeacion>> buscarPlaneacionesPorNombre(String nombre) async {
    final maps = await db.query(
      'planeaciones',
      where: 'nombre LIKE ?',
      whereArgs: ['%$nombre%'],
    );

    return List.generate(maps.length, (i) {
      return Planeacion.fromJson(maps[i]);
    });
  }
}
