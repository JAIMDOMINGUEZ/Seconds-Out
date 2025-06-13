import 'package:intl/intl.dart';

class PruebaTecnica {
  final int? id_prueba;
  final int idAtleta;
  final DateTime fecha;
  final int puntajeTotal;

  PruebaTecnica({
    this.id_prueba,
    required this.idAtleta,
    required this.fecha,
    required this.puntajeTotal,
  });


  factory PruebaTecnica.fromMap(Map<String, dynamic> map) {
    return PruebaTecnica(
      id_prueba: map['id_prueba'],
      idAtleta: map['id_atleta'],
      fecha: DateTime.parse(map['fecha']),
      puntajeTotal: map['puntajeTotal'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id_prueba != null) 'id_prueba': id_prueba,
      'id_atleta': idAtleta,
      'fecha': fecha.toIso8601String(),
      'puntajeTotal': puntajeTotal,
    };
  }


  String formatearFecha() {
    return DateFormat('dd/MM/yy').format(fecha);
  }


  PruebaTecnica copyWith({
    int? id_prueba,
    int? idAtleta,
    DateTime? fecha,
    int? puntajeTotal,
  }) {
    return PruebaTecnica(
      id_prueba: id_prueba ?? this.id_prueba,
      idAtleta: idAtleta ?? this.idAtleta,
      fecha: fecha ?? this.fecha,
      puntajeTotal: puntajeTotal ?? this.puntajeTotal,
    );
  }
}