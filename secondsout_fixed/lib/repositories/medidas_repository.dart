import 'package:sqflite/sqflite.dart';
import '/data/models/medidaantropometrica.dart';

class MedidasRepository {
  final Database _database;
  static const String _tableName = 'medidas_antropometricas';

  MedidasRepository(this._database);

  Future<List<MedidaAntropometrica>> obtenerMedidas() async {
    final List<Map<String, dynamic>> maps = await _database.query(
      _tableName,
      orderBy: 'fecha DESC',
    );
    return maps.map((map) => MedidaAntropometrica.fromLocalMap(map)).toList();
  }

  Future<int> insertarMedida(MedidaAntropometrica medida) async {
    return await _database.insert(_tableName, medida.toLocalMap());
  }

  Future<int> actualizarMedida(MedidaAntropometrica medida) async {
    return await _database.update(
      _tableName,
      medida.toLocalMap(),
      where: 'idMedida = ?',
      whereArgs: [medida.idMedida],
    );
  }

  Future<int> eliminarMedida(int idMedida) async {
    return await _database.delete(
      _tableName,
      where: 'idMedida = ?',
      whereArgs: [idMedida],
    );
  }
  Future<List<MedidaAntropometrica>> obtenerMedidasPorAtleta(int atletaId) async {
    final maps = await _database.query(
      'medidas_antropometricas',
      where: 'idAtleta = ?',
      whereArgs: [atletaId],
    );
    return maps.map((map) => MedidaAntropometrica.fromLocalMap(map)).toList();
  }
  Future<MedidaAntropometrica?> obtenerMedidaMasReciente(int atletaId) async {
    final maps = await _database.query(
      'medidas_antropometricas',
      where: 'idAtleta = ?',
      whereArgs: [atletaId],
      orderBy: 'fecha DESC',
      limit: 1,
    );
    return maps.isNotEmpty ? MedidaAntropometrica.fromLocalMap(maps.first) : null;
  }
}
