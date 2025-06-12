import 'package:flutter/material.dart';
import 'admin_entrenadores_screen.dart';
import 'admin_atletas_screen.dart';
import 'admin_ejercicios_screen.dart';
import 'admin_planeacion_screen.dart';
import 'perfil_screen.dart';
import 'admin_grupos_screen.dart';

enum UserRole { admin, entrenador, atleta }

class MenuScreen extends StatelessWidget {
  final UserRole userRole;

  const MenuScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Menú Principal'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.person, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilScreen(
                      isAthlete: userRole == UserRole.atleta,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (userRole == UserRole.entrenador || userRole == UserRole.admin)
                _buildMenuOption(
                  context,
                  icon: Icons.people,
                  title: 'Atletas',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminAtletasScreen(),
                    ),
                  ),
                ),
              if (userRole == UserRole.entrenador || userRole == UserRole.admin)
                const SizedBox(height: 16),

              if (userRole == UserRole.admin)
                _buildMenuOption(
                  context,
                  icon: Icons.sports,
                  title: 'Entrenadores',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminEntrenadoresScreen(),
                    ),
                  ),
                ),
              if (userRole == UserRole.admin) const SizedBox(height: 16),

              if (userRole != UserRole.admin)
                _buildMenuOption(
                  context,
                  icon: Icons.group,
                  title: 'Grupos',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminGruposScreen(),
                    ),
                  ),
                ),
              if (userRole != UserRole.admin) const SizedBox(height: 16),

              if (userRole == UserRole.entrenador)
                _buildMenuOption(
                  context,
                  icon: Icons.fitness_center,
                  title: 'Ejercicios',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminEjerciciosScreen(),
                    ),
                  ),
                ),
              if (userRole == UserRole.entrenador) const SizedBox(height: 16),

              if (userRole == UserRole.entrenador)
                _buildMenuOption(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Planeaciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPlaneacionScreen(),
                    ),
                  ),
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