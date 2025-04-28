import 'package:floor/floor.dart';
import 'atleta.dart';
@Entity(
  tableName: 'medidas_antropometricas',
  foreignKeys: [
    ForeignKey(
      childColumns: ['atletaId'],
      parentColumns: ['id'],
      entity: Atleta,
    )
  ],
)
class MedidaAntropometrica {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int atletaId;
  final String somatotipo;
  final double imc;
  final DateTime fecha;

  MedidaAntropometrica({
    this.id,
    required this.atletaId,
    required this.somatotipo,
    required this.imc,
    required this.fecha,
  });

  factory MedidaAntropometrica.fromJson(Map<String, dynamic> json) => MedidaAntropometrica(
        id: json['id'],
        atletaId: json['atletaId'],
        somatotipo: json['somatotipo'],
        imc: json['imc'].toDouble(),
        fecha: DateTime.parse(json['fecha']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'atletaId': atletaId,
        'somatotipo': somatotipo,
        'imc': imc,
        'fecha': fecha.toIso8601String(),
      };
}
