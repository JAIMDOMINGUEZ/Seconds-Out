import 'package:sqflite/sqflite.dart';
import '/data/models/prueba_tecnica.dart';

class PruebasTecnicasRepository {
  final Database db;

  PruebasTecnicasRepository(this.db);

  // Obtener todas las pruebas de un atleta
  Future<List<PruebaTecnica>> obtenerPruebasPorAtleta(int atletaId) async {
    print('Obteniendo pruebas para el atleta con ID: $atletaId');
    final pruebas = await db.query(
      'pruebas_tecnicas',
      where: 'id_atleta = ?',
      whereArgs: [atletaId],
      orderBy: 'fecha DESC',
    );
    print('Pruebas obtenidas: ${pruebas.length}');
    for (var prueba in pruebas) {
      print('Prueba: $prueba');
    }
    return pruebas.map((e) => PruebaTecnica.fromMap(e)).toList();
  }

  // Agregar una nueva prueba
  Future<int> agregarPrueba(PruebaTecnica prueba) async {
    print('Agregando nueva prueba: ${prueba.toMap()}');
    final id = await db.insert('pruebas_tecnicas', prueba.toMap());
    print('Prueba insertada con ID: $id');
    return id;
  }

  // Actualizar una prueba existente
  Future<int> actualizarPrueba(PruebaTecnica prueba) async {
    print('Actualizando prueba con ID: ${prueba.id_prueba}');
    final count = await db.update(
      'pruebas_tecnicas',
      prueba.toMap(),
      where: 'id_prueba = ?',
      whereArgs: [prueba.id_prueba],
    );
    print('Número de registros actualizados: $count');
    return count;
  }

  // Eliminar una prueba
  Future<int> eliminarPrueba(int idPrueba) async {
    print('Eliminando prueba con ID: $idPrueba');
    final count = await db.delete(
      'pruebas_tecnicas',
      where: 'id_prueba = ?',
      whereArgs: [idPrueba],
    );
    print('Número de registros eliminados: $count');
    return count;
  }

  // Obtener una prueba por su ID
  Future<PruebaTecnica?> obtenerPruebaPorId(int idPrueba) async {
    print('Buscando prueba con ID: $idPrueba');
    final pruebas = await db.query(
      'pruebas_tecnicas',
      where: 'id_prueba = ?',
      whereArgs: [idPrueba],
      limit: 1,
    );

    if (pruebas.isEmpty) {
      print('No se encontró la prueba con ID: $idPrueba');
      return null;
    }

    print('Prueba encontrada: ${pruebas.first}');

    return PruebaTecnica.fromMap(pruebas.first);
  }
}
