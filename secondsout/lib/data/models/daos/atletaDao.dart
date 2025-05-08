import 'package:floor/floor.dart';

import '../atleta.dart';
@dao
abstract class AtletaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAtleta(Atleta atleta);

  @Query('SELECT * FROM atletas WHERE grupoId = :grupoId')
  Future<List<Atleta>> getAtletasByGrupo(int grupoId);

  @Query('SELECT * FROM atletas WHERE id = :id')
  Future<Atleta?> getAtletaById(int id);

  @Query('DELETE FROM atletas WHERE id = :id')
  Future<void> deleteAtleta(int id);
}