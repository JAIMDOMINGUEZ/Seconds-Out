import 'package:floor/floor.dart';

import '../prueba_psicologica.dart';
import '../prueba_tactica.dart';

@dao
abstract class PruebaTacticaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPruebaTactica(PruebaTactica prueba);

  @Query('SELECT * FROM pruebas_tacticas WHERE pruebaTecnicaId = :id')
  Future<PruebaTactica?> getByPruebaId(int id);
}

@dao
abstract class PruebaPsicologicaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPruebaPsicologica(PruebaPsicologica prueba);

  @Query('SELECT * FROM pruebas_psicologicas WHERE pruebaTecnicaId = :id')
  Future<PruebaPsicologica?> getByPruebaId(int id);
}