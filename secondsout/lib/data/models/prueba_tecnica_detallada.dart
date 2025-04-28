
import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_tecnicas_detalladas')
class PruebaTecnicaDetallada {
  @PrimaryKey()
  final int pruebaTecnicaId; // Relación 1:1 con PruebaTecnica
  final int tecnicaGolpeo;
  final int distanciaGolpeo;

  PruebaTecnicaDetallada({
    required this.pruebaTecnicaId,
    required this.tecnicaGolpeo,
    required this.distanciaGolpeo,
  });

  factory PruebaTecnicaDetallada.fromJson(Map<String, dynamic> json) => PruebaTecnicaDetallada(
        pruebaTecnicaId: json['pruebaTecnicaId'],
        tecnicaGolpeo: json['tecnicaGolpeo'],
        distanciaGolpeo: json['distanciaGolpeo'],
      );

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'tecnicaGolpeo': tecnicaGolpeo,
        'distanciaGolpeo': distanciaGolpeo,
      };
}