import 'package:flutter/material.dart';
import 'admin_entrenadores_screen.dart';
import 'admin_atletas_screen.dart';
import 'admin_ejercicios_screen.dart';
import 'admin_planeacion_screen.dart';
import 'login_screen.dart';
import 'perfil_screen.dart';
import 'admin_grupos_screen.dart';



enum UserRole { admin, entrenador, atleta }

class MenuApp extends StatelessWidget {
  final int idUsuario;
  final String  rol;

  const MenuApp({
    super.key,
    required this.idUsuario,
    required this.rol,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menú Principal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MenuScreen(idUsuario: 0, rol: '',),
    );
  }
}
UserRole getUserRoleFromString(String rol) {
  return UserRole.values.firstWhere(
        (e) => e.name == rol,
    orElse: () => UserRole.atleta, // valor por defecto si no encuentra coincidencia
  );
}

class MenuScreen extends StatelessWidget {
  final int idUsuario;
  final String rol;
  const MenuScreen({super.key,  required this.idUsuario, required this.rol});

  @override
  Widget build(BuildContext context) {

    final UserRole userRole = getUserRoleFromString(rol);

    return WillPopScope(
      onWillPop: () async => false, // Evita retroceder con el botón físico
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menú'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.person, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PerfilScreen(isAthlete: userRole == UserRole.atleta),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                        ),
                        TextButton(
                          child: const Text('Cerrar sesión'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),


        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Atletas (solo entrenador)
              if (userRole == UserRole.entrenador)
                _buildMenuOption(
                  context,
                  icon: Icons.people,
                  title: 'Atletas',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminAtletasScreen(),
                      ),
                    );
                  },
                ),
              if (userRole == UserRole.entrenador) const SizedBox(height: 16),

              // Entrenadores (solo admin)
              if (userRole == UserRole.admin)
                _buildMenuOption(
                  context,
                  icon: Icons.sports,
                  title: 'Entrenadores',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminEntrenadoresScreen(),
                      ),
                    );
                  },
                ),
              if (userRole == UserRole.admin) const SizedBox(height: 16),

              // Grupos (entrenador y atleta)
              if (userRole == UserRole.entrenador ||
                  userRole == UserRole.atleta)
                _buildMenuOption(
                  context,
                  icon: Icons.group,
                  title: 'Grupos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminGruposScreen(),
                      ),
                    );
                  },
                ),
              if (userRole == UserRole.entrenador ||
                  userRole == UserRole.atleta)
                const SizedBox(height: 16),

              // Ejercicios (solo entrenador)
              if (userRole == UserRole.entrenador)
                _buildMenuOption(
                  context,
                  icon: Icons.fitness_center,
                  title: 'Ejercicios',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminEjerciciosScreen(),
                      ),
                    );
                  },
                ),
              if (userRole == UserRole.entrenador) const SizedBox(height: 16),

              // Planeaciones (solo entrenador)
              if (userRole == UserRole.entrenador)
                _buildMenuOption(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Planeaciones',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPlaneacionScreen(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}