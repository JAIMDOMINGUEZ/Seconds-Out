import 'package:floor/floor.dart';

import '../prueba_tecnica_detallada.dart';

@dao
abstract class PruebaTecnicaDetalladaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDetalle(PruebaTecnicaDetallada detalle);

  @Query('SELECT * FROM pruebas_tecnicas_detalladas WHERE pruebaTecnicaId = :id')
  Future<PruebaTecnicaDetallada?> getByPruebaId(int id);
}