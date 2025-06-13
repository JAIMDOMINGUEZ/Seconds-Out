import 'package:floor/floor.dart';
@Entity(tableName: 'pruebas_fisicas')
class PruebaFisica {
  @PrimaryKey(autoGenerate: true)
  final int? id_prueba_fisica;  // nullable para autoincrement

  final int id_prueba;          // FK a pruebas_tecnicas

  final int resistencia;
  final int rapidez;
  final int fuerza;
  final int reaccion;
  final int explosividad;
  final int coordinacion;
  final int puntajeTotal;

  PruebaFisica({
    this.id_prueba_fisica,
    required this.id_prueba,
    required this.resistencia,
    required this.rapidez,
    required this.fuerza,
    required this.reaccion,
    required this.explosividad,
    required this.coordinacion,
    required this.puntajeTotal,
  });

  // Constructor para crear una prueba física calculando puntaje
  factory PruebaFisica.conPuntajeCalculado({
    int? id_prueba_fisica,
    required int id_prueba,
    required int resistencia,
    required int rapidez,
    required int fuerza,
    required int reaccion,
    required int explosividad,
    required int coordinacion,
  }) {
    final total = resistencia + rapidez + fuerza + reaccion + explosividad + coordinacion;
    return PruebaFisica(
      id_prueba_fisica: id_prueba_fisica,
      id_prueba: id_prueba,
      resistencia: resistencia,
      rapidez: rapidez,
      fuerza: fuerza,
      reaccion: reaccion,
      explosividad: explosividad,
      coordinacion: coordinacion,
      puntajeTotal: total,
    );
  }


  int calcularPuntajeTotal() {
    return resistencia + rapidez + fuerza + reaccion + explosividad + coordinacion;
  }

  factory PruebaFisica.fromJson(Map<String, dynamic> json) => PruebaFisica(
    id_prueba: json['id_prueba'],
    id_prueba_fisica: json['id_prueba_fisica'],
    resistencia: json['resistencia'],
    rapidez: json['rapidez'],
    fuerza: json['fuerza'],
    reaccion: json['reaccion'],
    explosividad: json['explosividad'],
    coordinacion: json['coordinacion'],
    puntajeTotal: json['puntajeTotal'],
  );

  Map<String, dynamic> toJson() => {
    'id_prueba': id_prueba,
    'id_prueba_fisica': id_prueba_fisica,
    'resistencia': resistencia,
    'rapidez': rapidez,
    'fuerza': fuerza,
    'reaccion': reaccion,
    'explosividad': explosividad,
    'coordinacion': coordinacion,
    'puntajeTotal': puntajeTotal,
  };
}
