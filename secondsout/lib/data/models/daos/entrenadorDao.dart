import 'package:floor/floor.dart';

import '../entrenador.dart';

@dao
abstract class EntrenadorDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEntrenador(Entrenador entrenador);

  @Update()
  Future<void> updateEntrenador(Entrenador entrenador);

  @Query('SELECT * FROM entrenadores')
  Future<List<Entrenador>> getAllEntrenadores();

  @Query('SELECT * FROM entrenadores WHERE id = :id')
  Future<Entrenador?> getEntrenadorById(int id);

  @Query('DELETE FROM entrenadores WHERE id = :id')
  Future<void> deleteEntrenador(int id);
}