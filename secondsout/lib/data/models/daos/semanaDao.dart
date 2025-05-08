import 'package:floor/floor.dart';

import '../semana.dart';
@dao
abstract class SemanaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSemana(Semana semana);

  @Query('SELECT * FROM semanas WHERE planeacionId = :planeacionId')
  Future<List<Semana>> getSemanasByPlaneacion(int planeacionId);
}