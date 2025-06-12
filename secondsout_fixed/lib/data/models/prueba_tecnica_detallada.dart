import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_tecnicas_detalladas')
class PruebaTecnicaDetallada {
  @PrimaryKey()
  final int id_prueba;

  final int id_prueba_tecnica_detallada;
  final int tecnicaGolpeo;
  final int distanciaGolpeo;
  final int movilidad;
  final int tecnica_defensiva;
  final int variabilidad_defensiva;
  final int puntajeTotal;

  PruebaTecnicaDetallada({
    required this.id_prueba,
    required this.id_prueba_tecnica_detallada,
    required this.tecnicaGolpeo,
    required this.distanciaGolpeo,
    required this.movilidad,
    required this.tecnica_defensiva,
    required this.variabilidad_defensiva,
    required this.puntajeTotal,
  });

  factory PruebaTecnicaDetallada.conPuntajeCalculado({
    required int id_prueba,
    required int id_prueba_tecnica_detallada,
    required int tecnicaGolpeo,
    required int distanciaGolpeo,
    required int movilidad,
    required int tecnica_defensiva,
    required int variabilidad_defensiva,
  }) {
    int total = tecnicaGolpeo +
        distanciaGolpeo +
        movilidad +
        tecnica_defensiva +
        variabilidad_defensiva;

    return PruebaTecnicaDetallada(
      id_prueba: id_prueba,
      id_prueba_tecnica_detallada: id_prueba_tecnica_detallada,
      tecnicaGolpeo: tecnicaGolpeo,
      distanciaGolpeo: distanciaGolpeo,
      movilidad: movilidad,
      tecnica_defensiva: tecnica_defensiva,
      variabilidad_defensiva: variabilidad_defensiva,
      puntajeTotal: total,
    );
  }

  int calcularPuntajeTotal() {
    return tecnicaGolpeo +
        distanciaGolpeo +
        movilidad +
        tecnica_defensiva +
        variabilidad_defensiva;
  }

  factory PruebaTecnicaDetallada.fromJson(Map<String, dynamic> json) =>
      PruebaTecnicaDetallada(
        id_prueba: json['id_prueba'],
        id_prueba_tecnica_detallada: json['id_prueba_tecnica_detallada'],
        tecnicaGolpeo: json['tecnicaGolpeo'],
        distanciaGolpeo: json['distanciaGolpeo'],
        movilidad: json['movilidad'],
        tecnica_defensiva: json['tecnica_defensiva'],
        variabilidad_defensiva: json['variabilidad_defensiva'],
        puntajeTotal: json['puntajeTotal'],
      );

  Map<String, dynamic> toJson() => {
    'id_prueba': id_prueba,
    'id_prueba_tecnica_detallada': id_prueba_tecnica_detallada,
    'tecnicaGolpeo': tecnicaGolpeo,
    'distanciaGolpeo': distanciaGolpeo,
    'movilidad': movilidad,
    'tecnica_defensiva': tecnica_defensiva,
    'variabilidad_defensiva': variabilidad_defensiva,
    'puntajeTotal': puntajeTotal,
  };
}
