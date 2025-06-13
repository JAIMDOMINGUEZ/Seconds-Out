/*import 'package:sqflite/sqflite.dart';
import '/data/services/migracion_service.dart';

Future<void> realizarMigracion() async {
  final db = await openDatabase('ruta_a_tu_db.db');

  await migrarUsuarios(db);
  await migrarAtletas(db);
  await migrarEntrenadores(db);
  await migrarAdministradores(db);
  await migrarEjercicios(db);
  await migrarGrupos(db);
  await migrarGrupoAtletas(db);
  await migrarPlaneaciones(db);
  await migrarSemanas(db);
  await migrarSesiones(db);
  await migrarEjerciciosAsignados(db);
  await migrarPlaneacionGrupo(db);
  await migrarMedidas(db);
  await migrarPruebasTecnicas(db);
  await migrarPruebasFisicas(db);
  await migrarPruebasTacticas(db);
  await migrarPruebasTecnicasDetalladas(db);
  await migrarPruebasPsicologicas(db);
  await migrarPruebasReglas(db);

  await db.close();
}
*/