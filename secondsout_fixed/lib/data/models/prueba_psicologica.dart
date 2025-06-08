import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_psicologicas')
class PruebaPsicologica {
  @PrimaryKey()
  final int pruebaTecnicaId;
  final int autocontrol;
  final int combatividad;
  final int iniciativa;

  PruebaPsicologica({
    required this.pruebaTecnicaId,
    required this.autocontrol,
    required this.combatividad,
    required this.iniciativa,
  });

  factory PruebaPsicologica.fromJson(Map<String, dynamic> json) => PruebaPsicologica(
        pruebaTecnicaId: json['pruebaTecnicaId'] as int,
        autocontrol: json['autocontrol'] as int,
        combatividad: json['combatividad'] as int,
        iniciativa: json['iniciativa'] as int,
      );

  get puntajeTotal => null;

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'autocontrol': autocontrol,
        'combatividad': combatividad,
        'iniciativa': iniciativa,
      };
}