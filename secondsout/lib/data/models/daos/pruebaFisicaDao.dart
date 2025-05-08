import 'package:floor/floor.dart';

import '../prueba_fisica.dart';
@dao
abstract class PruebaFisicaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPruebaFisica(PruebaFisica prueba);

  @Query('SELECT * FROM pruebas_fisicas WHERE pruebaTecnicaId = :pruebaId')
  Future<PruebaFisica?> getPruebaByTecnicaId(int pruebaId);
}