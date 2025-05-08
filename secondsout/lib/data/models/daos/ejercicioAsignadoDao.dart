import 'package:floor/floor.dart';

import '../ejercicio_asignado.dart';
@dao
abstract class EjercicioAsignadoDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEjercicioAsignado(EjercicioAsignado ejercicio);

  @Query('SELECT * FROM ejercicios_asignados WHERE sesionId = :sesionId')
  Future<List<EjercicioAsignado>> getEjerciciosBySesion(int sesionId);

  @Query('DELETE FROM ejercicios_asignados WHERE id = :id')
  Future<void> deleteEjercicioAsignado(int id);
}