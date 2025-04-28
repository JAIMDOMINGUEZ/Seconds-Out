import 'package:floor/floor.dart';
import 'atleta.dart';

@Entity(
  tableName: 'pruebas_tecnicas',
  foreignKeys: [
    ForeignKey(
      childColumns: ['atletaId'],
      parentColumns: ['id'],
      entity: Atleta,
    )
  ],
)
class PruebaTecnica {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int atletaId;
  final DateTime fecha;
  final String observaciones;
  final int puntajeTotal;

  PruebaTecnica({
    this.id,
    required this.atletaId,
    required this.fecha,
    required this.observaciones,
    required this.puntajeTotal,
  });

  // Firebase
  factory PruebaTecnica.fromJson(Map<String, dynamic> json) => PruebaTecnica(
        id: json['id'],
        atletaId: json['atletaId'],
        fecha: DateTime.parse(json['fecha']),
        observaciones: json['observaciones'],
        puntajeTotal: json['puntajeTotal'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'atletaId': atletaId,
        'fecha': fecha.toIso8601String(),
        'observaciones': observaciones,
        'puntajeTotal': puntajeTotal,
      };
}