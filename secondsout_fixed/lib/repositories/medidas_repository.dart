import 'package:sqflite/sqflite.dart';
import '/data/models/medidaantropometrica.dart';

class MedidasRepository {
  final Database _database;
  static const String _tableName = 'medidas_antropometricas';

  MedidasRepository(this._database);

  Future<List<MedidaAntropometrica>> obtenerMedidas() async {
    //print('Obteniendo todas las medidas antropométricas...');
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      orderBy: 'fecha DESC',
    );
    //print('Cantidad de medidas obtenidas: ${maps.length}');
    return maps.map((map) => MedidaAntropometrica.fromLocalMap(map)).toList();
  }

  Future<int> insertarMedida(MedidaAntropometrica medida) async {
    //print('Insertando medida: ${medida.toLocalMap()}');
    final id = await _database.insert(_tableName, medida.toLocalMap());
    //print('Medida insertada con id: $id');
    return id;
  }

  Future<int> actualizarMedida(MedidaAntropometrica medida) async {
    //print('Actualizando medida id: ${medida.idMedida}, datos: ${medida.toLocalMapForUpdate()}');
    final count = await _database.update(
      _tableName,
      medida.toLocalMapForUpdate(),
      where: 'id_medida = ?',
      whereArgs: [medida.idMedida],
    );
    print('Cantidad de registros actualizados: $count');
    return count;
  }



  Future<int> eliminarMedida(int idMedida) async {
    //print('Eliminando medida con id: $idMedida');
    final count = await _database.delete(
      _tableName,
      where: 'id_medida = ?',
      whereArgs: [idMedida],
    );
    //print('Cantidad de registros eliminados: $count');
    return count;
  }

  Future<List<MedidaAntropometrica>> obtenerMedidasPorAtleta(int atletaId) async {
    //print('Obteniendo medidas para atleta id: $atletaId');
    final maps = await _database.query(
      _tableName,
      where: 'id_atleta = ?',
      whereArgs: [atletaId],
    );
    //print('Medidas obtenidas para atleta $atletaId: ${maps.length}');
    return maps.map((map) => MedidaAntropometrica.fromLocalMap(map)).toList();
  }

  Future<MedidaAntropometrica?> obtenerMedidaMasReciente(int atletaId) async {
    try {
      //print('Obteniendo medida más reciente para atleta id: $atletaId');
      final maps = await _database.query(
        _tableName,
        where: 'id_atleta = ?',
        whereArgs: [atletaId],
        orderBy: 'fecha DESC',
        limit: 1,
      );

      if (maps.isNotEmpty) {
        final map = maps.first;
        // Verifica valores nulos antes de crear el objeto
        if (map['id_medida'] == null) {
          throw Exception('El campo id_medida es nulo en la base de datos');
        }
        return MedidaAntropometrica.fromLocalMap(map);
      }
      return null;
    } catch (e) {
      //print('Error en obtenerMedidaMasReciente: $e');
      rethrow;
    }
  }
}
