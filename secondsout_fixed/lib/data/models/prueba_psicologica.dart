import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_psicologicas')
class PruebaPsicologica {
  @PrimaryKey()
  final int id_prueba;

  final int id_prueba_psicologica;
  final int autocontrol;
  final int combatividad;
  final int iniciativa;
  final int puntajeTotal;

  PruebaPsicologica({
    required this.id_prueba,
    required this.id_prueba_psicologica,
    required this.autocontrol,
    required this.combatividad,
    required this.iniciativa,
    required this.puntajeTotal,
  });


  factory PruebaPsicologica.conPuntajeCalculado({
    required int id_prueba,
    required int id_prueba_psicologica,
    required int autocontrol,
    required int combatividad,
    required int iniciativa,
  }) {
    int total = autocontrol + combatividad + iniciativa;
    return PruebaPsicologica(
      id_prueba: id_prueba,
      id_prueba_psicologica: id_prueba_psicologica,
      autocontrol: autocontrol,
      combatividad: combatividad,
      iniciativa: iniciativa,
      puntajeTotal: total,
    );
  }

  factory PruebaPsicologica.fromJson(Map<String, dynamic> json) =>
      PruebaPsicologica(
        id_prueba: json['id_prueba'],
        id_prueba_psicologica: json['id_prueba_psicologica'],
        autocontrol: json['autocontrol'],
        combatividad: json['combatividad'],
        iniciativa: json['iniciativa'],
        puntajeTotal: json['puntajeTotal'],
      );

  Map<String, dynamic> toJson() => {
    'id_prueba': id_prueba,
    'id_prueba_psicologica': id_prueba_psicologica,
    'autocontrol': autocontrol,
    'combatividad': combatividad,
    'iniciativa': iniciativa,
    'puntajeTotal': puntajeTotal,
  };


  int calcularPuntajeTotal() {
    return autocontrol + combatividad + iniciativa;
  }
}
