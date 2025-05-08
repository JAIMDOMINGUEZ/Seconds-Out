
import 'package:floor/floor.dart';

import '../usuario.dart';
@dao
abstract class UsuarioDao {
  @Query('SELECT * FROM usuarios WHERE id = :id')
  Future<Usuario?> getUsuarioById(int id);

  @Query('SELECT * FROM usuarios WHERE correo = :correo')
  Future<Usuario?> getUsuarioByCorreo(String correo);
}