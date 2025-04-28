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
    required this.rapidez,
  });

  factory PruebaFisica.fromJson(Map<String, dynamic> json) => PruebaFisica(
        pruebaTecnicaId: json['pruebaTecnicaId'],
        resistencia: json['resistencia'],
        rapidez: json['rapidez'],
      );

  Map<String, dynamic> toJson() => {
        'pruebaTecnicaId': pruebaTecnicaId,
        'resistencia': resistencia,
        'rapidez': rapidez,
      };
}