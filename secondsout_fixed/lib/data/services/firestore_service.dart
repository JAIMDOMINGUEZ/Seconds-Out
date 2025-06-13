/*
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==== USUARIOS ====
  Future<void> agregarUsuario(Usuario usuario) async {
    await _db.collection('usuarios').add({
      'nombre': usuario.nombre,
      'correo': usuario.correo,
      'contrasena': usuario.contrasena,
      'fechaNacimiento': usuario.fechaNacimiento,
    });
  }

  // ==== ATLETAS ====
  Future<void> agregarAtleta(int idUsuario) async {
    await _db.collection('atletas').add({
      'id_usuario': idUsuario,
    });
  }

  // ==== ENTRENADORES ====
  Future<void> agregarEntrenador(int idUsuario) async {
    await _db.collection('entrenadores').add({
      'id_usuario': idUsuario,
    });
  }

  // ==== ADMINISTRADORES ====
  Future<void> agregarAdministrador(int idUsuario) async {
    await _db.collection('administradores').add({
      'id_usuario': idUsuario,
    });
  }

  // ==== EJERCICIOS ====
  Future<void> agregarEjercicio({
    required String nombre,
    required String tipo,
    required String descripcion,
  }) async {
    await _db.collection('ejercicios').add({
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
    });
  }

  // ==== GRUPOS ====
  Future<void> agregarGrupo({
    required String nombre,
    required int capacidadMaxima,
  }) async {
    await _db.collection('grupos').add({
      'nombre': nombre,
      'capacidadMaxima': capacidadMaxima,
    });
  }

  // ==== GRUPO-ATLETAS ====
  Future<void> agregarGrupoAtleta({
    required int idGrupo,
    required int idAtleta,
  }) async {
    await _db.collection('grupo_atletas').add({
      'id_grupo': idGrupo,
      'id_atleta': idAtleta,
    });
  }

  // ==== PLANEACIONES ====
  Future<void> agregarPlaneacion({
    required String nombre,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    await _db.collection('planeaciones').add({
      'nombre': nombre,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
    });
  }

  // ==== SEMANAS ====
  Future<void> agregarSemana({
    required int idPlaneacion,
    String? nombre,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    await _db.collection('semanas').add({
      'id_planeacion': idPlaneacion,
      'nombre': nombre,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
    });
  }

  // ==== SESIONES ====
  Future<void> agregarSesion({
    required int idSemana,
    required String nombre,
  }) async {
    await _db.collection('sesiones').add({
      'id_semana': idSemana,
      'nombre': nombre,
    });
  }

  // ==== EJERCICIOS ASIGNADOS ====
  Future<void> agregarEjercicioAsignado({
    required int idSesion,
    required int idEjercicio,
    required int repeticiones,
    required int tiempoDescanso,
    required int tiempoTrabajo,
  }) async {
    await _db.collection('ejercicio_asignado').add({
      'id_sesion': idSesion,
      'id_ejercicio': idEjercicio,
      'repeticiones': repeticiones,
      'tiempoDescanso': tiempoDescanso,
      'tiempoTrabajo': tiempoTrabajo,
    });
  }

  // ==== PLANEACION-GRUPO ====
  Future<void> agregarPlaneacionGrupo({
    required int idPlaneacion,
    required int idGrupo,
  }) async {
    await _db.collection('planeacion_grupo').add({
      'id_planeacion': idPlaneacion,
      'id_grupo': idGrupo,
    });
  }

  // ==== MEDIDAS ANTROPOMÉTRICAS ====
  Future<void> agregarMedidaAntropometrica({
    required int idAtleta,
    required double peso,
    required double talla,
    String? somatotipo,
    double? imc,
    double? cinturaCadera,
    double? seisPliegues,
    double? ochoPliegues,
    double? pGraso,
    double? pMuscular,
    double? pOseo,
    required String fecha,
  }) async {
    await _db.collection('medidas_antropometricas').add({
      'id_atleta': idAtleta,
      'peso': peso,
      'talla': talla,
      'somatotipo': somatotipo,
      'imc': imc,
      'cintura_cadera': cinturaCadera,
      'seis_pliegues': seisPliegues,
      'ocho_pliegues': ochoPliegues,
      'p_graso': pGraso,
      'p_muscular': pMuscular,
      'p_oseo': pOseo,
      'fecha': fecha,
    });
  }

  // ==== PRUEBAS TÉCNICAS ====
  Future<void> agregarPruebaTecnica({
    required int idAtleta,
    required String fecha,
    required int puntajeTotal,
  }) async {
    await _db.collection('pruebas_tecnicas').add({
      'id_atleta': idAtleta,
      'fecha': fecha,
      'puntajeTotal': puntajeTotal,
    });
  }

  // ==== PRUEBAS FÍSICAS ====
  Future<void> agregarPruebaFisica({
    required int idAtleta,
    required String fecha,
    required String nombre,
    required double resultado,
  }) async {
    await _db.collection('pruebas_fisicas').add({
      'id_atleta': idAtleta,
      'fecha': fecha,
      'nombre': nombre,
      'resultado': resultado,
    });
  }

  // ==== PRUEBAS TÁCTICAS ====
  Future<void> agregarPruebaTactica({
    required int idAtleta,
    required String fecha,
    required String descripcion,
    required int puntuacion,
  }) async {
    await _db.collection('pruebas_tacticas').add({
      'id_atleta': idAtleta,
      'fecha': fecha,
      'descripcion': descripcion,
      'puntuacion': puntuacion,
    });
  }

  // ==== PRUEBAS PSICOLÓGICAS ====
  Future<void> agregarPruebaPsicologica({
    required int idAtleta,
    required String fecha,
    required String test,
    required int resultado,
  }) async {
    await _db.collection('pruebas_psicologicas').add({
      'id_atleta': idAtleta,
      'fecha': fecha,
      'test': test,
      'resultado': resultado,
    });
  }

  // ==== PRUEBAS TÉCNICAS DETALLADAS ====
  Future<void> agregarPruebaTecnicaDetallada({
    required int idPruebaTecnica,
    required String nombreEjercicio,
    required int puntaje,
  }) async {
    await _db.collection('pruebas_tecnicas_detalladas').add({
      'id_prueba_tecnica': idPruebaTecnica,
      'nombre_ejercicio': nombreEjercicio,
      'puntaje': puntaje,
    });
  }

  // ==== PRUEBAS REGLAS ====
  Future<void> agregarPruebaReglas({
    required int idAtleta,
    required String fecha,
    required int aciertos,
    required int fallos,
  }) async {
    await _db.collection('pruebas_reglas').add({
      'id_atleta': idAtleta,
      'fecha': fecha,
      'aciertos': aciertos,
      'fallos': fallos,
    });
  }
}
*/