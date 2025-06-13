import 'package:sqflite/sqflite.dart';
import '/data/models/planeacion_grupo.dart';

class PlaneacionGrupoRepository {
  final Database db;

  PlaneacionGrupoRepository(this.db);

  Future<int> insertarPlaneacionGrupo(PlaneacionGrupo pg) async {
    //print('Insertando PlaneacionGrupo: ${pg.toJson()}');
    final result = await db.insert('planeacion_grupo', pg.toJson());
    //print('Insertado con ID: $result');
    return result;
  }

  Future<List<PlaneacionGrupo>> obtenerTodos() async {
    //print('Obteniendo todos los registros de planeacion_grupo');
    final List<Map<String, dynamic>> maps = await db.query('planeacion_grupo');
    final grupos = List.generate(maps.length, (i) {
      return PlaneacionGrupo.fromJson(maps[i]);
    });
    print('Obtenidos ${grupos.length} registros');
    return grupos;
  }

  Future<int> eliminarPorId(int id) async {
    //print('Eliminando PlaneacionGrupo con ID: $id');
    final result = await db.delete(
      'planeacion_grupo',
      where: 'id_planeacion_grupo = ?',
      whereArgs: [id],
    );
    //print('Número de registros eliminados: $result');
    return result;
  }

  Future<int> actualizarPlaneacionGrupo(PlaneacionGrupo pg) async {
    //print('Actualizando PlaneacionGrupo con ID: ${pg.id_planeacion_grupo}');
    //print('Datos nuevos: ${pg.toJson()}');
    final result = await db.update(
      'planeacion_grupo',
      pg.toJson(),
      where: 'id_planeacion_grupo = ?',
      whereArgs: [pg.id_planeacion_grupo],
    );
    //print('Número de registros actualizados: $result');
    return result;
  }
}
