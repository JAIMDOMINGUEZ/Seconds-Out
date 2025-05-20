import 'package:floor/floor.dart';

@Entity(tableName: 'pruebas_fisicas')
class PruebaFisica {
  @PrimaryKey()
  final int pruebaTecnicaId; // Relación 1:1 con PruebaTecnica
  final int resistencia;
  final int rapidez;

  PruebaFisica({
    required this.pruebaTecnicaId,
    required this.resistencia,
    required this.rapidez, required int fuerza, required int reaccion, required int explosividad, required int coordinacion,
  });

  get puntajeTotal => null;

  get fuerza => null;

  get reaccion => null;

  get explosividad => null;

  get coordinacion => null;
/*
  factory PruebaFisica.fromJson(Map<String, dynamic> json) => PruebaFisica(
        pruebaTecnicaId: json['pruebaTecnicaId'],
        resistencia: json['resistencia'],
        rapidez: json['rapidez'], fuerza: ['fuerza'],
      );
*/
  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'resistencia': resistencia,
        'rapidez': rapidez,
      };
}