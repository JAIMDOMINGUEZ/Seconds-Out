/*
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;

/// Usuarios
Future<void> migrarUsuarios(Database db) async {
  final usuarios = await db.query('usuarios');
  for (var usuario in usuarios) {
    await firestore.collection('usuarios').add(usuario);
  }
}

/// Entrenadores
Future<void> migrarEntrenadores(Database db) async {
  final entrenadores = await db.query('entrenadores');
  for (var entrenador in entrenadores) {
    await firestore.collection('entrenadores').add(entrenador);
  }
}

/// Atletas
Future<void> migrarAtletas(Database db) async {
  final atletas = await db.query('atletas');
  for (var atleta in atletas) {
    await firestore.collection('atletas').add(atleta);
  }
}

/// Ejercicios
Future<void> migrarEjercicios(Database db) async {
  final ejercicios = await db.query('ejercicios');
  for (var ejercicio in ejercicios) {
    await firestore.collection('ejercicios').add(ejercicio);
  }
}

/// Grupos
Future<void> migrarGrupos(Database db) async {
  final grupos = await db.query('grupos');
  for (var grupo in grupos) {
    await firestore.collection('grupos').add(grupo);
  }
}

/// Grupo Atletas
Future<void> migrarGrupoAtletas(Database db) async {
  final grupoAtletas = await db.query('grupo_atletas');
  for (var ga in grupoAtletas) {
    await firestore.collection('grupo_atletas').add(ga);
  }
}

/// Medidas antropométricas
Future<void> migrarMedidas(Database db) async {
  final medidas = await db.query('medidas_antropometricas');
  for (var medida in medidas) {
    await firestore.collection('medidas_antropometricas').add(medida);
  }
}

/// Planeaciones
Future<void> migrarPlaneaciones(Database db) async {
  final planeaciones = await db.query('planeaciones');
  for (var planeacion in planeaciones) {
    await firestore.collection('planeaciones').add(planeacion);
  }
}

/// Semanas
Future<void> migrarSemanas(Database db) async {
  final semanas = await db.query('semanas');
  for (var semana in semanas) {
    await firestore.collection('semanas').add(semana);
  }
}

/// Sesiones
Future<void> migrarSesiones(Database db) async {
  final sesiones = await db.query('sesiones');
  for (var sesion in sesiones) {
    await firestore.collection('sesiones').add(sesion);
  }
}

/// Ejercicios asignados
Future<void> migrarEjerciciosAsignados(Database db) async {
  final ejerciciosAsignados = await db.query('ejercicio_asignado');
  for (var ea in ejerciciosAsignados) {
    await firestore.collection('ejercicio_asignado').add(ea);
  }
}

/// Planeación Grupo
Future<void> migrarPlaneacionGrupo(Database db) async {
  final planeacionGrupo = await db.query('planeacion_grupo');
  for (var pg in planeacionGrupo) {
    await firestore.collection('planeacion_grupo').add(pg);
  }
}

/// Pruebas Técnicas
Future<void> migrarPruebasTecnicas(Database db) async {
  final pruebasTecnicas = await db.query('pruebas_tecnicas');
  for (var pt in pruebasTecnicas) {
    await firestore.collection('pruebas_tecnicas').add(pt);
  }
}

/// Pruebas Físicas
Future<void> migrarPruebasFisicas(Database db) async {
  final pruebasFisicas = await db.query('pruebas_fisicas');
  for (var pf in pruebasFisicas) {
    await firestore.collection('pruebas_fisicas').add(pf);
  }
}

/// Pruebas Tácticas
Future<void> migrarPruebasTacticas(Database db) async {
  final pruebasTacticas = await db.query('pruebas_tacticas');
  for (var pt in pruebasTacticas) {
    await firestore.collection('pruebas_tacticas').add(pt);
  }
}

/// Pruebas Técnicas Detalladas
Future<void> migrarPruebasTecnicasDetalladas(Database db) async {
  final pruebasDetalladas = await db.query('pruebas_tecnicas_detalladas');
  for (var ptd in pruebasDetalladas) {
    await firestore.collection('pruebas_tecnicas_detalladas').add(ptd);
  }
}

/// Pruebas Psicológicas
Future<void> migrarPruebasPsicologicas(Database db) async {
  final pruebasPsicologicas = await db.query('pruebas_psicologicas');
  for (var pp in pruebasPsicologicas) {
    await firestore.collection('pruebas_psicologicas').add(pp);
  }
}

/// Pruebas Reglas
Future<void> migrarPruebasReglas(Database db) async {
  final pruebasReglas = await db.query('pruebas_reglas');
  for (var pr in pruebasReglas) {
    await firestore.collection('pruebas_reglas').add(pr);
  }
}

/// Administradores
Future<void> migrarAdministradores(Database db) async {
  final administradores = await db.query('administradores');
  for (var admin in administradores) {
    await firestore.collection('administradores').add(admin);
  }
}
*/