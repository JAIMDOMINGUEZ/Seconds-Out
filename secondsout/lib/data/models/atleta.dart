import 'package:floor/floor.dart';
import 'usuario.dart';

@Entity(
  tableName: 'atletas',
  foreignKeys: [ForeignKey(childColumns: ['usuarioId'], parentColumns: ['id'], entity: Usuario)],
)
class Atleta {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int usuarioId;
  final DateTime fechaNacimiento;
  final String categoria;

  Atleta({this.id, required this.usuarioId, required this.fechaNacimiento, required this.categoria});

  factory Atleta.fromJson(Map<String, dynamic> json) => Atleta(
    id: json['id'],
    usuarioId: json['usuarioId'],
    fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
    categoria: json['categoria'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'fechaNacimiento': fechaNacimiento.toIso8601String(),
    'categoria': categoria,
  };
}
