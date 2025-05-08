import 'package:floor/floor.dart';

import '../grupo.dart';
@dao
abstract class GrupoDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGrupo(Grupo grupo);

  @Query('SELECT * FROM grupos WHERE entrenadorId = :entrenadorId')
  Future<List<Grupo>> getGruposByEntrenador(int entrenadorId);
}