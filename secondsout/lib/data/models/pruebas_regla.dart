import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_reglas')
class PruebaReglas {
  @PrimaryKey()
  final int pruebaTecnicaId;
  final int faltasTecnicas;
  final int conductaCombativa;

  PruebaReglas({
    required this.pruebaTecnicaId,
    required this.faltasTecnicas,
    required this.conductaCombativa,
  });

  factory PruebaReglas.fromJson(Map<String, dynamic> json) => PruebaReglas(
        pruebaTecnicaId: json['pruebaTecnicaId'] as int,
        faltasTecnicas: json['faltasTecnicas'] as int,
        conductaCombativa: json['conductaCombativa'] as int,
      );

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'faltasTecnicas': faltasTecnicas,
        'conductaCombativa': conductaCombativa,
      };
}