import 'package:floor/floor.dart';

@Entity(tableName: 'evaluaciones_pruebas')
class EvaluacionPrueba {
  @PrimaryKey()
  final int pruebaTecnicaId;
  final int puntajeFisico;
  final int puntajeTecnico;
  final String calificacionFinal; // Ej: "Excelente"

  EvaluacionPrueba({
    required this.pruebaTecnicaId,
    required this.puntajeFisico,
    required this.puntajeTecnico,
    required this.calificacionFinal,
  });

  factory EvaluacionPrueba.fromJson(Map<String, dynamic> json) => EvaluacionPrueba(
        pruebaTecnicaId: json['pruebaTecnicaId'] as int,
        puntajeFisico: json['puntajeFisico'] as int,
        puntajeTecnico: json['puntajeTecnico'] as int,
        calificacionFinal: json['calificacionFinal'] as String,
      );

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'puntajeFisico': puntajeFisico,
        'puntajeTecnico': puntajeTecnico,
        'calificacionFinal': calificacionFinal,
      };
}