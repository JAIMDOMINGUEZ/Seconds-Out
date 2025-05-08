import 'package:floor/floor.dart';

import '../medidaantropometrica.dart';
@dao
abstract class MedidaAntropometricaDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMedida(MedidaAntropometrica medida);

  @Query('SELECT * FROM medidas_antropometricas WHERE atletaId = :atletaId')
  Future<List<MedidaAntropometrica>> getMedidasByAtleta(int atletaId);
}