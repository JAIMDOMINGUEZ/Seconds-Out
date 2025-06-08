import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../repositories/entrenador_repository.dart';
import '../models/entrenador.dart';
import '../models/usuario.dart';


class DatabaseService {
  static const _databaseName = 'secondsout_v3.db'; // Incrementa la versión
  static const _databaseVersion = 1;

  static Future<Database> initializeDB() async {
    final dbPath = join(await getDatabasesPath(), _databaseName);
    await databaseFactory.deleteDatabase(dbPath); // Elimina si existe


    final db = await openDatabase(
      dbPath,
      onCreate: _onCreate,
      version: _databaseVersion,
    );
    await DatabaseService.debugDatabase(db);
    await _insertarDatosDePrueba(db); // Insertar datos de prueba
    return db;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        idUsuario INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT NOT NULL ,
        contrasena TEXT NOT NULL,
        fechaNacimiento TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE entrenadores (
        id_entrenador INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES usuarios(idUsuario)
      )
    ''');
    await db.execute('''
    CREATE TABLE atletas (
      id_atleta INTEGER PRIMARY KEY AUTOINCREMENT,
      id_usuario INTEGER NOT NULL,
      FOREIGN KEY (id_usuario) REFERENCES usuarios(idUsuario)
    )
    ''');

    await db.execute('''
    CREATE TABLE ejercicios (
      id_ejercicio INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      tipo TEXT NOT NULL,
      descripcion TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE grupos (
      id_grupo INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      capacidadMaxima INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE grupo_atletas (
      id_grupo_atleta INTEGER PRIMARY KEY AUTOINCREMENT,
      id_grupo INTEGER NOT NULL,
      id_atleta INTEGER NOT NULL,
      FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo),
      FOREIGN KEY (id_atleta) REFERENCES atletas(id_atleta)
    )
  ''');
    await db.execute('''
    CREATE TABLE medidas_antropometricas (
      id_medida INTEGER PRIMARY KEY AUTOINCREMENT,
      peso REAL NOT NULL,
      talla REAL NOT NULL,
      somatotipo TEXT,
      imc REAL,
      cintura_cadera REAL,
      seis_pliegues REAL,
      ocho_pliegues REAL,
      p_graso REAL,
      p_muscular REAL,
      p_oseo REAL,
      fecha TEXT NOT NULL UNIQUE
    )
  ''');
    await db.execute('''
    CREATE TABLE planeaciones (
        id_planeacion INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        fecha_inicio TEXT,
        fecha_fin TEXT
        
    )
    ''');
    await db.execute('''
    CREATE TABLE semanas (
        id_semana INTEGER PRIMARY KEY AUTOINCREMENT,
        id_planeacion INTEGER NOT NULL,
        nombre TEXT,
        fecha_inicio TEXT,
        fecha_fin TEXT,
        FOREIGN KEY (id_planeacione) REFERENCES planeaciones(id_planeacione)
    )
    ''');
    await db.execute('''
    CREATE TABLE sesiones (
        id_sesion INTEGER PRIMARY KEY AUTOINCREMENT,
        id_semana INTEGER NOT NULL,
        nombre TEXT NOT NULL, 
       
        FOREIGN KEY (id_semana) REFERENCES semanas(id_semana)
    )
    ''');
    await db.execute('''
  CREATE TABLE ejercicio_asignado (
    id_ejercicio_asignado INTEGER PRIMARY KEY AUTOINCREMENT,
    id_sesion INTEGER NOT NULL,
    id_ejercicio INTEGER NOT NULL,
    repeticiones INTEGER NOT NULL,
    tiempoDescanso INTEGER NOT NULL,
    tiempoTrabajo INTEGER NOT NULL,
    FOREIGN KEY (id_sesion) REFERENCES sesiones(id_sesion),
    FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio)
  )
  ''');


  }

  static Future<void> _insertarDatosDePrueba(Database db) async {
    try {
      // Insertar usuarios primero
      final idUsuario1 = await db.insert('usuarios', {
        'nombre': 'Carlos Mendoza',
        'correo': 'carlos@box.com',
        'contrasena': '123456',
        'fechaNacimiento': '1980-05-10',
      });

      final idUsuario2 = await db.insert('usuarios', {
        'nombre': 'Lucía Ramírez',
        'correo': 'lucia@box.com',
        'contrasena': '654321',
        'fechaNacimiento': '1985-09-15',
      });

      // Insertar entrenadores usando el repositorio
      final repo = EntrenadorRepository(db);

      await repo.insertarEntrenador(Entrenador(
        idEntrenador: 0, // 0 para autoincremento
        idUsuario: idUsuario1,
        usuario: Usuario(
          idUsuario: idUsuario1,
          nombre: 'Carlos Mendoza',
          correo: 'carlos@box.com',
          contrasena: '123456',
          fechaNacimiento: '1980-05-10',
        ),
      ));

      await repo.insertarEntrenador(Entrenador(
        idEntrenador: 0, // 0 para autoincremento
        idUsuario: idUsuario2,
        usuario: Usuario(
          idUsuario: idUsuario2,
          nombre: 'Lucía Ramírez',
          correo: 'lucia@box.com',
          contrasena: '654321',
          fechaNacimiento: '1985-09-15',
        ),
      ));

      debugPrint('✅ Datos de prueba insertados correctamente');
    } catch (e) {
      debugPrint('❌ Error insertando datos de prueba: $e');
    }
  }

  static Future<void> debugDatabase(Database db) async {
    debugPrint('\n=== ESTRUCTURA ACTUAL ===');
    final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table'");

    for (var table in tables) {
      final tableName = table['name'];
      final columns = await db.rawQuery("PRAGMA table_info($tableName)");
      debugPrint('\nTabla: $tableName');
      for (var col in columns) {
        debugPrint('${col['name']} (${col['type']})');
      }

      // Mostrar datos de cada tabla
      //final data = await db.query(tableName);
      //debugPrint('Datos: ${data.toString()}');
    }
  }
}