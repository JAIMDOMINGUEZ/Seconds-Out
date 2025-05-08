import 'package:floor/floor.dart';

import '../prueba_tecnica.dart';
@dao
abstract class PruebaTecnicaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPrueba(PruebaTecnica prueba);

  @Query('SELECT * FROM pruebas_tecnicas WHERE atletaId = :atletaId')
  Future<List<PruebaTecnica>> getPruebasByAtleta(int atletaId);

  @Query('DELETE FROM pruebas_tecnicas WHERE id = :id')
  Future<void> deletePrueba(int id);
}