import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secondsout_fixed/repositories/ejercicio_asignado_repository.dart';
import 'package:secondsout_fixed/repositories/planeacion_repository.dart' show PlaneacionRepository;
import 'package:secondsout_fixed/screens/admin_medidas_screen.dart' show AdminMedidasScreen;
import 'package:secondsout_fixed/screens/admin_planeacion_screen.dart';
import 'package:secondsout_fixed/viewmodels/ejercicio_asignado_view_model.dart';
import 'package:secondsout_fixed/viewmodels/planeacion_grupo_view_model.dart';
import 'package:secondsout_fixed/viewmodels/usuario_view_model.dart';
//import '/migrates/controles.dart';
import 'package:sqflite/sqflite.dart';

// Servicios y repositorios
import 'data/services/database_service.dart';
import 'repositories/atleta_repository.dart';
import 'repositories/ejercicio_repository.dart';
import 'repositories/entrenador_repository.dart';
import 'repositories/grupo_atleta_repository.dart';
import 'repositories/grupo_repository.dart';
import 'repositories/medidas_repository.dart';
import 'repositories/semana_repository.dart';
import 'repositories/usuario_repository.dart';
import 'viewmodels/prueba_tecnica_view_model.dart';
import 'repositories/prueba_tecnica_repository.dart';

// ViewModels
import 'screens/admin_semana_screen.dart';
import 'viewmodels/admin_atletas_view_model.dart';
import 'viewmodels/admin_entrenadores_view_model.dart';
import 'viewmodels/admin_ejercicios_view_model.dart';
import 'viewmodels/admin_grupo_view_model.dart';
import 'viewmodels/admin_medidas_view_model.dart';
import 'viewmodels/admin_pleaneaciones_view_model.dart';
import 'viewmodels/admin_semana_view_model.dart';
import 'viewmodels/grupo_view_model.dart' hide GrupoViewModel;


import 'screens/login_screen.dart';
import 'screens/admin_entrenadores_screen.dart';
import 'screens/admin_atletas_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final database = await DatabaseService.initializeDB();
    //realizarMigracion();
    runApp(
      MultiProvider(
        providers: [
          // Base de datos
          Provider<Database>(create: (_) => database),

          // Repositorios
          Provider<AtletaRepository>(
            create: (context) => AtletaRepository(context.read<Database>()),
          ),
          Provider<GrupoAtletaRepository>(
            create: (context) => GrupoAtletaRepository(context.read<Database>()),
          ),
          Provider<GrupoRepository>(
            create: (context) => GrupoRepository(context.read<Database>()),
          ),
          Provider<EntrenadorRepository>(
            create: (context) => EntrenadorRepository(context.read<Database>()),
          ),
          Provider<UsuarioRepository>(
            create: (context) => UsuarioRepository(context.read<Database>()),
          ),
          Provider<EjercicioRepository>(
            create: (context) => EjercicioRepository(context.read<Database>()),
          ),
          Provider<MedidasRepository>(
            create: (context) => MedidasRepository(context.read<Database>()),
          ),

          // ViewModels
          ChangeNotifierProvider(
            create: (context) => AdminEntrenadoresViewModel(
              context.read<EntrenadorRepository>(),
              context.read<UsuarioRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AdminAtletasViewModel(
              context.read<AtletaRepository>(),
              context.read<UsuarioRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => EjercicioViewModel(
              context.read<EjercicioRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => GrupoViewModel(
              context.read<GrupoRepository>(),
              grupoAtletaRepository: context.read<GrupoAtletaRepository>(),
              atletaRepository: context.read<AtletaRepository>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AdminMedidasViewModel(
              context.read<MedidasRepository>(),
            ),
          ),
          //planeacion
          Provider<PlaneacionRepository>(
            create: (context) => PlaneacionRepository(context.read<Database>()),
          ),

          ChangeNotifierProvider<AdminPlaneacionesViewModel>(
            create: (context) => AdminPlaneacionesViewModel(
              context.read<PlaneacionRepository>(),
            ),
          ),
          // Change this in your main.dart
          // Database and repositories first
          Provider<Database>(create: (_) => database),
          Provider<SemanaRepository>(
            create: (context) => SemanaRepository(context.read<Database>()),
          ),

          // Then view models
          ChangeNotifierProvider<SemanaViewModel>(
            create: (context) => SemanaViewModel(
              context.read<SemanaRepository>(),
            ),
          ),
          //ejercicio asignado
          Provider<EjercicioAsignadoRepository>(
            create: (context) => EjercicioAsignadoRepository(context.read<Database>()),
          ),

          Provider<EjercicioRepository>(
            create: (context) => EjercicioRepository(context.read<Database>()),
          ),

          ChangeNotifierProvider(create: (_) => EjercicioAsignadoViewModel(
            ejercicioAsignadoRepository: EjercicioAsignadoRepository(database),
            ejercicioRepository: EjercicioRepository(database),
          )),


          Provider<PruebasTecnicasRepository>(
            create: (context) => PruebasTecnicasRepository(context.read<Database>()),
          ),


          ChangeNotifierProvider(
            create: (context) => PruebasTecnicasViewModel(
              context.read<PruebasTecnicasRepository>(),
            ),
          ),

          ChangeNotifierProvider(
            create: (context) => PlaneacionGrupoViewModel(
              database: context.read<Database>(),
            ),
          ),


          ChangeNotifierProvider<UsuarioViewModel>(
            create: (context) => UsuarioViewModel(context.read<UsuarioRepository>()),
          ),




        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al iniciar la aplicación')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Entrenadores',
      debugShowCheckedModeBanner: false,

      initialRoute: '/login',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Aquí usamos onGenerateRoute para heredar correctamente los Providers
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/admin':
            return MaterialPageRoute(builder: (_) => const AdminEntrenadoresScreen());
          case '/adminAtletas':
            return MaterialPageRoute(builder: (_) => const AdminAtletasScreen());
          case '/adminPlaneaciones':
            return MaterialPageRoute(builder: (_) => const AdminPlaneacionScreen());
          case '/adminSemanas':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => AdminSemanaScreen(
                nombreMesociclo: args['nombreMesociclo'],
                fechaInicioMesociclo: args['fechaInicio'],
                fechaFinMesociclo: args['fechaFin'],
                idPlaneacion: args['idPlaneacion'],
              ),
            );
        // Agrega tus demás pantallas aquí...
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Ruta no encontrada')),
              ),
            );
        }
      },
    );
  }
}
