import 'package:sqflite/sqflite.dart';
import '../data/models/atleta.dart';
import '../data/models/usuario.dart';
import '../data/models/grupo_atleta.dart';

class GrupoAtletaRepository {
  final Database db;

  GrupoAtletaRepository(this.db);

  /// Agregar atleta a grupo
  Future<int> agregarAtletaAGrupo(int idGrupo, int idAtleta) async {
   // print('Insertando atleta $idAtleta en grupo $idGrupo...');
    final result = await db.insert('grupo_atletas', {
      'id_grupo': idGrupo,
      'id_atleta': idAtleta,
    });
    //print('Insertado con resultado: $result');
    return result;
  }

  /// Eliminar atleta de grupo
  Future<void> eliminarAtletaDeGrupo(int idGrupo, int idAtleta) async {
    //print('Eliminando atleta $idAtleta del grupo $idGrupo...');
    final count = await db.delete(
      'grupo_atletas',
      where: 'id_grupo = ? AND id_atleta = ?',
      whereArgs: [idGrupo, idAtleta],
    );
    //print('Filas eliminadas: $count');
  }

  /// Obtener atletas de un grupo
  Future<List<Atleta>> obtenerAtletasPorGrupo(int idGrupo) async {
    //print('Obteniendo atletas del grupo $idGrupo...');
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        a.id_atleta, a.id_usuario, u.nombre, u.correo, u.contrasena, u.fechaNacimiento
      FROM grupo_atletas ga
      JOIN atletas a ON ga.id_atleta = a.id_atleta
      JOIN usuarios u ON a.id_usuario = u.idUsuario
      WHERE ga.id_grupo = ?
    ''', [idGrupo]);

    //print('Se encontraron ${maps.length} atletas en el grupo $idGrupo');

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

  Future<List<int>> obtenerIdsAtletasPorGrupo(int idGrupo) async {
    //print('Obteniendo IDs de atletas del grupo $idGrupo...');
    final List<Map<String, dynamic>> maps = await db.query(
      'grupo_atletas',
      columns: ['id_atleta'],
      where: 'id_grupo = ?',
      whereArgs: [idGrupo],
    );

    final ids = maps.map((e) => e['id_atleta'] as int).toList();
    print('IDs encontrados: $ids');
    return ids;
  }
}
