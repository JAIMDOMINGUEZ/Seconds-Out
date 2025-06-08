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
      'idMedida': idMedida,  // <-- corregido aquí
      'idAtleta': idAtleta,
      'peso': peso,
      'talla': talla,
      'somatotipo': somatotipo,
      'imc': imc,
      'cinturaCadera': cinturaCadera,
      'seisPliegues': seisPliegues,
      'ochoPliegues': ochoPliegues,
      'porcentajeGraso': porcentajeGraso,
      'porcentajeMuscular': porcentajeMuscular,
      'porcentajeOseo': porcentajeOseo,
      'fecha': fecha.toIso8601String(),
    };
  }


  factory MedidaAntropometrica.fromLocalMap(Map<String, dynamic> map) {
    return MedidaAntropometrica(
      idMedida: map['idMedida'],
      idAtleta: map['idAtleta'],
      peso: map['peso'],
      talla: map['talla'],
      somatotipo: map['somatotipo'],
      imc: map['imc'],
      cinturaCadera: map['cinturaCadera'],
      seisPliegues: map['seisPliegues'],
      ochoPliegues: map['ochoPliegues'],
      porcentajeGraso: map['porcentajeGraso'],
      porcentajeMuscular: map['porcentajeMuscular'],
      porcentajeOseo: map['porcentajeOseo'],
      fecha: DateTime.parse(map['fecha']),


    );
  }



}