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


  Atleta({this.id, required this.usuarioId, required this.fechaNacimiento});

  factory Atleta.fromJson(Map<String, dynamic> json) => Atleta(
    id: json['id'],
    usuarioId: json['usuarioId'],
    fechaNacimiento: DateTime.parse(json['fechaNacimiento'])
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'fechaNacimiento': fechaNacimiento.toIso8601String(),

  };
}
