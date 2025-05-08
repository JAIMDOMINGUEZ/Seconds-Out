import 'package:floor/floor.dart';

import '../administrador.dart';

@dao
abstract class AdministradorDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAdministrador(Administrador admin);

  @Query('SELECT * FROM administradores WHERE id = :id')
  Future<Administrador?> getAdministradorById(int id);
}