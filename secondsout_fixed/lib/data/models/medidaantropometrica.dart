import 'package:floor/floor.dart';
import 'atleta.dart';

class MedidaAntropometrica {
  final int idMedida;
  final int idAtleta;
  final double peso;
  final double talla;
  final String somatotipo;
  final double imc;
  final double? cinturaCadera;
  final double? seisPliegues;
  final double? ochoPliegues;
  final double? porcentajeGraso;
  final double? porcentajeMuscular;
  final double? porcentajeOseo;
  final DateTime fecha;


  MedidaAntropometrica({
    required this.idMedida,
    required this.idAtleta,
    required this.peso,
    required this.talla,
    required this.somatotipo,
    required this.imc,
    this.cinturaCadera,
    this.seisPliegues,
    this.ochoPliegues,
    this.porcentajeGraso,
    this.porcentajeMuscular,
    this.porcentajeOseo,
    required this.fecha,

  });

  Map<String, dynamic> toLocalMap() {
    return {
      'id_atleta': idAtleta,
      'peso': peso,
      'talla': talla,
      'somatotipo': somatotipo,
      'imc': imc,
      'cintura_cadera': cinturaCadera,
      'seis_pliegues': seisPliegues,
      'ocho_pliegues': ochoPliegues,
      'p_graso': porcentajeGraso,
      'p_muscular': porcentajeMuscular,
      'p_oseo': porcentajeOseo,
      'fecha': fecha.toIso8601String(),
    };
  }
  Map<String, Object?> toLocalMapForUpdate() {
    return {
      'id_medida': idMedida,
      'id_atleta': idAtleta,
      'peso': peso,
      'talla': talla,
      'somatotipo': somatotipo,
      'imc': imc,
      'cintura_cadera': cinturaCadera,
      'seis_pliegues': seisPliegues,
      'ocho_pliegues': ochoPliegues,
      'p_graso': porcentajeGraso,
      'p_muscular': porcentajeMuscular,
      'p_oseo': porcentajeOseo,
      'fecha': fecha.toIso8601String(),
    };
  }


  factory MedidaAntropometrica.fromLocalMap(Map<String, dynamic> map) {
    return MedidaAntropometrica(
      idMedida: map['id_medida'] is int
          ? map['id_medida']
          : int.tryParse(map['id_medida'].toString()) ?? 0,
      idAtleta: map['id_atleta'] is int
          ? map['id_atleta']
          : int.tryParse(map['id_atleta'].toString()) ?? 0,
      peso: (map['peso'] as num).toDouble(),
      talla: (map['talla'] as num).toDouble(),
      somatotipo: map['somatotipo'] ?? '',
      imc: (map['imc'] as num).toDouble(),
      cinturaCadera: map['cintura_cadera'] != null ? (map['cintura_cadera'] as num).toDouble() : null,
      seisPliegues: map['seis_pliegues'] != null ? (map['seis_pliegues'] as num).toDouble() : null,
      ochoPliegues: map['ocho_pliegues'] != null ? (map['ocho_pliegues'] as num).toDouble() : null,
      porcentajeGraso: map['p_graso'] != null ? (map['p_graso'] as num).toDouble() : null,
      porcentajeMuscular: map['p_muscular'] != null ? (map['p_muscular'] as num).toDouble() : null,
      porcentajeOseo: map['p_oseo'] != null ? (map['p_oseo'] as num).toDouble() : null,
      fecha: DateTime.parse(map['fecha']),
    );
  }






}