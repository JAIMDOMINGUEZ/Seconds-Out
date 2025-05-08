import 'package:floor/floor.dart';

import '../ejercicio.dart';
import '../sesion.dart';

@dao
abstract class SesionDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSesion(Sesion sesion);

  @Query('SELECT * FROM sesiones WHERE semanaId = :semanaId')
  Future<List<Sesion>> getBySemanaId(int semanaId);
}

@dao
abstract class EjercicioDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEjercicio(Ejercicio ejercicio);

  @Query('SELECT * FROM ejercicios WHERE id = :id')
  Future<Ejercicio?> getEjercicioById(int id);

  @Query('SELECT * FROM ejercicios WHERE tipo = :tipo')
  Future<List<Ejercicio>> getByTipo(String tipo);
}