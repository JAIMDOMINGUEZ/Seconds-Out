import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_tacticas')
class PruebaTactica {
  @PrimaryKey()
  final int id_prueba;

  final int id_prueba_tactica;
  final int distanciaCombate;
  final int preparacionOfensiva;
  final int eficienciaAtaque;
  final int eficienciaContraataque;
  final int entradaDistanciaCorta;
  final int salidaCuerpoACuerpo;
  final int puntajeTotal;

  PruebaTactica({
    required this.id_prueba,
    required this.id_prueba_tactica,
    required this.distanciaCombate,
    required this.preparacionOfensiva,
    required this.eficienciaAtaque,
    required this.eficienciaContraataque,
    required this.entradaDistanciaCorta,
    required this.salidaCuerpoACuerpo,
    required this.puntajeTotal,
  });

  factory PruebaTactica.conPuntajeCalculado({
    required int id_prueba,
    required int id_prueba_tactica,
    required int distanciaCombate,
    required int preparacionOfensiva,
    required int eficienciaAtaque,
    required int eficienciaContraataque,
    required int entradaDistanciaCorta,
    required int salidaCuerpoACuerpo,
  }) {
    int total = distanciaCombate +
        preparacionOfensiva +
        eficienciaAtaque +
        eficienciaContraataque +
        entradaDistanciaCorta +
        salidaCuerpoACuerpo;

    return PruebaTactica(
      id_prueba: id_prueba,
      id_prueba_tactica: id_prueba_tactica,
      distanciaCombate: distanciaCombate,
      preparacionOfensiva: preparacionOfensiva,
      eficienciaAtaque: eficienciaAtaque,
      eficienciaContraataque: eficienciaContraataque,
      entradaDistanciaCorta: entradaDistanciaCorta,
      salidaCuerpoACuerpo: salidaCuerpoACuerpo,
      puntajeTotal: total,
    );
  }

  int calcularPuntajeTotal() {
    return distanciaCombate +
        preparacionOfensiva +
        eficienciaAtaque +
        eficienciaContraataque +
        entradaDistanciaCorta +
        salidaCuerpoACuerpo;
  }

  factory PruebaTactica.fromJson(Map<String, dynamic> json) => PruebaTactica(
    id_prueba: json['id_prueba'],
    id_prueba_tactica: json['id_prueba_tactica'],
    distanciaCombate: json['distanciaCombate'],
    preparacionOfensiva: json['preparacionOfensiva'],
    eficienciaAtaque: json['eficienciaAtaque'],
    eficienciaContraataque: json['eficienciaContraataque'],
    entradaDistanciaCorta: json['entradaDistanciaCorta'],
    salidaCuerpoACuerpo: json['salidaCuerpoACuerpo'],
    puntajeTotal: json['puntajeTotal'],
  );

  Map<String, dynamic> toJson() => {
    'id_prueba': id_prueba,
    'id_prueba_tactica': id_prueba_tactica,
    'distanciaCombate': distanciaCombate,
    'preparacionOfensiva': preparacionOfensiva,
    'eficienciaAtaque': eficienciaAtaque,
    'eficienciaContraataque': eficienciaContraataque,
    'entradaDistanciaCorta': entradaDistanciaCorta,
    'salidaCuerpoACuerpo': salidaCuerpoACuerpo,
    'puntajeTotal': puntajeTotal,
  };
}
