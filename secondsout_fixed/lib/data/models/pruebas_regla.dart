import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_reglas')
class PruebaReglas {
  @PrimaryKey()
  final int id_prueba;

  final int id_prueba_regla;
  final int faltasTecnicas;
  final int conductaCombativa;
  final int puntajeTotal;

  PruebaReglas({
    required this.id_prueba,
    required this.id_prueba_regla,
    required this.faltasTecnicas,
    required this.conductaCombativa,
    required this.puntajeTotal,
  });


  factory PruebaReglas.conPuntajeCalculado({
    required int id_prueba,
    required int id_prueba_regla,
    required int faltasTecnicas,
    required int conductaCombativa,
  }) {
    int total = _calcularPuntaje(faltasTecnicas, conductaCombativa);
    return PruebaReglas(
      id_prueba: id_prueba,
      id_prueba_regla: id_prueba_regla,
      faltasTecnicas: faltasTecnicas,
      conductaCombativa: conductaCombativa,
      puntajeTotal: total,
    );
  }

  int calcularPuntajeTotal() {
    return _calcularPuntaje(faltasTecnicas, conductaCombativa);
  }

  static int _calcularPuntaje(int faltas, int conducta) {
    return   faltas + conducta;
  }

  factory PruebaReglas.fromJson(Map<String, dynamic> json) => PruebaReglas(
    id_prueba: json['id_prueba'],
    id_prueba_regla: json['id_prueba_regla'],
    faltasTecnicas: json['faltasTecnicas'],
    conductaCombativa: json['conductaCombativa'],
    puntajeTotal: json['puntajeTotal'],
  );

  Map<String, dynamic> toJson() => {
    'id_prueba': id_prueba,
    'id_prueba_regla': id_prueba_regla,
    'faltasTecnicas': faltasTecnicas,
    'conductaCombativa': conductaCombativa,
    'puntajeTotal': puntajeTotal,
  };
}
