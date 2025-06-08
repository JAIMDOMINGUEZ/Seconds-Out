import 'package:floor/floor.dart';

@Entity(primaryKeys: ['idAtleta', 'idGrupo'])
class AtletaGrupo {
  final int idAtleta;
  final int idGrupo;

  AtletaGrupo({
    required this.idAtleta,
    required this.idGrupo,
  });
}
