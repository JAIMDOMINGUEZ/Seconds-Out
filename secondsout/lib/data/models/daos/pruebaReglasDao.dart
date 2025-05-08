import 'package:floor/floor.dart';

import '../pruebas_regla.dart';

@dao
abstract class PruebaReglasDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPruebaReglas(PruebaReglas prueba);

  @Query('SELECT * FROM pruebas_reglas WHERE pruebaTecnicaId = :id')
  Future<PruebaReglas?> getByPruebaId(int id);
}