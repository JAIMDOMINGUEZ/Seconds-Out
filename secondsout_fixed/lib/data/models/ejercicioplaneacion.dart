import 'package:floor/floor.dart';

@Entity(primaryKeys: ['idEjercicio', 'idPlaneacion'])
class EjercicioPlaneacion {
  final int idEjercicio;
  final int idPlaneacion;

  EjercicioPlaneacion({
    required this.idEjercicio,
    required this.idPlaneacion,
  });
}
