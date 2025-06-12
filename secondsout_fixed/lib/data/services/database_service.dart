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
    id_atleta INTEGER NOT NULL,
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
    fecha TEXT NOT NULL ,
    FOREIGN KEY (id_atleta) REFERENCES atleta(id_atleta) ON DELETE CASCADE
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
        FOREIGN KEY (id_planeacion) REFERENCES planeaciones(id_planeacion)
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
  ''');await db.execute('''
   CREATE TABLE planeacion_grupo (
     id_planeacion_grupo INTEGER PRIMARY KEY AUTOINCREMENT,
     id_planeacion INTEGER NOT NULL,
     id_grupo INTEGER NOT NULL,
    FOREIGN KEY (id_planeacion) REFERENCES planeaciones(id_planeacion) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES grupos(id_grupo) ON DELETE CASCADE
  )
  ''');

  await db.execute('''
  CREATE TABLE pruebas_tecnicas (
    id_prueba INTEGER PRIMARY KEY AUTOINCREMENT,
    id_atleta INTEGER NOT NULL,
    fecha TEXT NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_atleta) REFERENCES atletas(id_atleta) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE pruebas_fisicas (
    id_prueba_fisica INTEGER PRIMARY KEY AUTOINCREMENT,
    id_prueba INTEGER NOT NULL,
    resistencia INTEGER NOT NULL,
    rapidez INTEGER NOT NULL,
    fuerza INTEGER NOT NULL,
    reaccion INTEGER NOT NULL,
    explosividad INTEGER NOT NULL,
    coordinacion INTEGER NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_prueba) REFERENCES pruebas_tecnicas(id_prueba) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE pruebas_tacticas (
    id_prueba_tactica INTEGER PRIMARY KEY AUTOINCREMENT,
    id_prueba INTEGER NOT NULL, 
    distanciaCombate INTEGER NOT NULL,
    preparacionOfensiva INTEGER NOT NULL,
    eficienciaAtaque INTEGER NOT NULL,
    eficienciaContraataque INTEGER NOT NULL,
    entradaDistanciaCorta INTEGER NOT NULL,
    salidaCuerpoACuerpo INTEGER NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_prueba) REFERENCES pruebas_tecnicas(id_prueba) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE pruebas_tecnicas_detalladas (
    id_prueba_tecnica_detallada INTEGER PRIMARY KEY AUTOINCREMENT,
    id_prueba INTEGER NOT NULL,
    tecnicaGolpeo INTEGER NOT NULL,
    distanciaGolpeo INTEGER NOT NULL,
    movilidad INTEGER NOT NULL,
    tecnica_defensiva INTEGER NOT NULL,
    variabilidad_defensiva INTEGER NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_prueba) REFERENCES pruebas_tecnicas(id_prueba) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE pruebas_psicologicas (
    id_prueba_psicologica INTEGER PRIMARY KEY AUTOINCREMENT,
    id_prueba INTEGER NOT NULL,
    autocontrol INTEGER NOT NULL,
    combatividad INTEGER NOT NULL,
    iniciativa INTEGER NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_prueba) REFERENCES pruebas_tecnicas(id_prueba) ON DELETE CASCADE
  )
''');
    await db.execute('''
    CREATE TABLE pruebas_reglas (
    pruebaTecnicaId INTEGER PRIMARY KEY AUTOINCREMENT,
    id_prueba INTEGER NOT NULL,
    faltasTecnicas INTEGER NOT NULL,
    conductaCombativa INTEGER NOT NULL,
    puntajeTotal INTEGER NOT NULL,
    FOREIGN KEY (id_prueba) REFERENCES pruebas_tecnicas(id_prueba) ON DELETE CASCADE
  )
''');

    //tirgers
    // Crear trigger para actualizar el puntaje total cuando se inserta/actualiza una prueba física
    await db.execute('''
  CREATE TRIGGER update_puntaje_total_fisico
  AFTER INSERT ON pruebas_fisicas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_fisico_update
  AFTER UPDATE ON pruebas_fisicas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal - OLD.puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');


    await db.execute('''
  CREATE TRIGGER update_puntaje_total_tactico
  AFTER INSERT ON pruebas_tacticas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_tactico_update
  AFTER UPDATE ON pruebas_tacticas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal - OLD.puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_tecnico
  AFTER INSERT ON pruebas_tecnicas_detalladas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_tecnico_update
  AFTER UPDATE ON pruebas_tecnicas_detalladas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal - OLD.puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_psicologico
  AFTER INSERT ON pruebas_psicologicas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');

    await db.execute('''
  CREATE TRIGGER update_puntaje_total_psicologico_update
  AFTER UPDATE ON pruebas_psicologicas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal - OLD.puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
  END;
''');
    await db.execute('''
  CREATE TRIGGER update_puntaje_total_reglas
  AFTER INSERT ON pruebas_reglas
  BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
    END;
  ''');

    await db.execute('''
    CREATE TRIGGER update_puntaje_total_reglas_update
    AFTER UPDATE ON pruebas_reglas
    BEGIN
    UPDATE pruebas_tecnicas
    SET puntajeTotal = puntajeTotal - OLD.puntajeTotal + NEW.puntajeTotal
    WHERE id_prueba = NEW.id_prueba;
    END;
    ''');



    await db.execute('''
  CREATE TABLE administradores (
    id_administrador INTEGER PRIMARY KEY AUTOINCREMENT,
    id_usuario INTEGER NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(idUsuario)
  )
''');

  }


  static Future<void> _insertarDatosDePrueba(Database db) async {
    try {
      // Insertar usuarios entrenadores
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

      final repo = EntrenadorRepository(db);

      await repo.insertarEntrenador(Entrenador(
        idEntrenador: 0,
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
        idEntrenador: 0,
        idUsuario: idUsuario2,
        usuario: Usuario(
          idUsuario: idUsuario2,
          nombre: 'Lucía Ramírez',
          correo: 'lucia@box.com',
          contrasena: '654321',
          fechaNacimiento: '1985-09-15',
        ),
      ));

      // Insertar usuarios administradores
      final idUsuario3 = await db.insert('usuarios', {
        'nombre': 'admin1',
        'correo': 'admin1@mya.com',
        'contrasena': 'Mr2liedt',
        'fechaNacimiento': '2001-09-01',
      });

      final idUsuario4 = await db.insert('usuarios', {
        'nombre': 'james_backster',
        'correo': 'james_backster@mya.com',
        'contrasena': 'Mr2liedt',
        'fechaNacimiento': '2001-09-01',
      });

      await insertarAdministradoresDePrueba(db, [idUsuario3, idUsuario4]);

      debugPrint(' Datos de prueba insertados correctamente');
    } catch (e) {
      debugPrint(' Error insertando datos de prueba: $e');
    }
  }
  static Future<void> insertarAdministradoresDePrueba(Database db, List<int> idUsuarios) async {
    try {
      for (var idUsuario in idUsuarios) {
        await db.insert('administradores', {
          'id_usuario': idUsuario,
        });
      }
      debugPrint('Administradores de prueba insertados correctamente');
    } catch (e) {
      debugPrint(' Error insertando administradores de prueba: $e');
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