import 'package:floor/floor.dart';
import 'package:secondsout/data/models/evaluacion_prueba.dart';
@dao
abstract class EvaluacionPruebaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertEvaluacion(EvaluacionPrueba evaluacion);

  @Query('SELECT * FROM evaluaciones_pruebas WHERE pruebaTecnicaId = :pruebaId')
  Future<EvaluacionPrueba?> getEvaluacionByPruebaId(int pruebaId);
}