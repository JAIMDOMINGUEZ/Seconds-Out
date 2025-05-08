import 'package:floor/floor.dart';

import '../planeacion.dart';
@dao
abstract class PlaneacionDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPlaneacion(Planeacion planeacion);

  @Query('SELECT * FROM planeaciones WHERE grupoId = :grupoId')
  Future<List<Planeacion>> getPlaneacionesByGrupo(int grupoId);

  @Query('DELETE FROM planeaciones WHERE id = :id')
  Future<void> deletePlaneacion(int id);
}