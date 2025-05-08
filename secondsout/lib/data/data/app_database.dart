import 'package:floor/floor.dart';
import '../models/daos/atletaDao.dart';
import '../models/daos/ejercicioAsignadoDao.dart';
import '../models/daos/entrenadorDao.dart';
import '../models/daos/evaluacionPruebaDao.dart';
import '../models/daos/grupoDao.dart';
import '../models/daos/medidaAntropometricaDao.dart';
import '../models/daos/planeacionDao.dart';
import '../models/daos/pruebaFisicaDao.dart';
import '../models/daos/pruebaReglasDao.dart';
import '../models/daos/pruebaTacticaDao.dart';
import '../models/daos/pruebaTecnicaDao.dart';
import '../models/daos/pruebaTecnicaDetallada.dart';
import '../models/daos/semanaDao.dart';
import '../models/daos/sesionDao.dart';
import '../models/usuario.dart';
import '../models/administrador.dart';
import '../models/atleta.dart';
import '../models/ejercicio.dart';
import '../models/ejercicio_asignado.dart';
import '../models/entrenador.dart';
import '../models/evaluacion_prueba.dart';
import '../models/grupo.dart';
import '../models/medidaantropometrica.dart';
import '../models/planeacion.dart';
import '../models/prueba_fisica.dart';
import '../models/prueba_psicologica.dart';
import '../models/prueba_tactica.dart';
import '../models/prueba_tecnica.dart';
import '../models/prueba_tecnica_detallada.dart';
import '../models/pruebas_regla.dart';
import '../models/semana.dart';
import '../models/sesion.dart';

@Database(
  version: 1,
  entities: [
    Usuario,
    Administrador,
    Entrenador,
    Atleta,
    Grupo,
    Ejercicio,
    EjercicioAsignado,
    Planeacion,
    Semana,
    Sesion,
    PruebaTecnica,
    PruebaFisica,
    PruebaTecnicaDetallada,
    PruebaTactica,
    PruebaPsicologica,
    PruebaReglas,
    EvaluacionPrueba,
    MedidaAntropometrica,
  ],
)
abstract class AppDatabase extends FloorDatabase {

  EntrenadorDao get entrenadorDao;
  AtletaDao get atletaDao;
  GrupoDao get grupoDao;
  EjercicioDao get ejercicioDao;
  EjercicioAsignadoDao get ejercicioAsignadoDao;
  PlaneacionDao get planeacionDao;
  SemanaDao get semanaDao;
  SesionDao get sesionDao;
  PruebaTecnicaDao get pruebaTecnicaDao;
  PruebaFisicaDao get pruebaFisicaDao;
  PruebaTecnicaDetalladaDao get pruebaTecnicaDetalladaDao;
  PruebaTacticaDao get pruebaTacticaDao;
  PruebaPsicologicaDao get pruebaPsicologicaDao;
  PruebaReglasDao get pruebaReglasDao;
  EvaluacionPruebaDao get evaluacionPruebaDao;
  MedidaAntropometricaDao get medidaAntropometricaDao;
}

