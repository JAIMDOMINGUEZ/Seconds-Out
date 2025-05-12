import 'package:floor/floor.dart';
@Entity(tableName: 'pruebas_tacticas')
class PruebaTactica {
  @PrimaryKey()
  final int pruebaTecnicaId; // Relación 1:1 con PruebaTecnica
  final int distanciaCombate;
  final int preparacionOfensiva;
  final int eficienciaAtaque;
  final int eficienciaContraataque;
  final int entradaDistanciaCorta;
  final int salidaCuerpoACuerpo;
  PruebaTactica({
    required this.pruebaTecnicaId,
    required this.distanciaCombate,
    required this.preparacionOfensiva,
    required this.eficienciaAtaque,
    required this.eficienciaContraataque,
    required this.entradaDistanciaCorta,
    required this.salidaCuerpoACuerpo,
  });

  factory PruebaTactica.fromJson(Map<String, dynamic> json) => PruebaTactica(
        pruebaTecnicaId: json['pruebaTecnicaId'] as int,
        distanciaCombate: json['distanciaCombate'] as int,
        preparacionOfensiva: json['preparacionOfensiva'] as int,
        eficienciaAtaque: json['eficienciaAtaque'] as int,
    eficienciaContraataque: json['eficienciaContraataque'] as int,
    entradaDistanciaCorta: json['entradaDistanciaCorta'] as int,
    salidaCuerpoACuerpo: json['salidaCuerpoACuerpo'] as int,
      );

  get puntajeTotal => null;

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'distanciaCombate': distanciaCombate,
        'preparacionOfensiva': preparacionOfensiva,
        'eficienciaAtaque': eficienciaAtaque,
      };
}