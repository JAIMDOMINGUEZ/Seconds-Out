import 'package:flutter/material.dart';
import 'admin_entrenadores_screen.dart';
import 'admin_atletas_screen.dart';
import 'admin_ejercicios_screen.dart';
import 'admin_planeacion_screen.dart';

import 'perfil_screen.dart';
import 'admin_grupos_screen.dart';
void main() {
  runApp(const MenuApp());
}

enum UserRole { admin, entrenador, atleta }

class MenuApp extends StatelessWidget {
  const MenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menú Principal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simular rol del usuario: cambia este valor para probar
    final UserRole userRole = UserRole.admin; // admin, entrenador, atleta

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/1.jpg',
              ),
              radius: 18,
            ),
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
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Atletas (solo admin y entrenador)
            if (userRole != UserRole.atleta)
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
            if (userRole != UserRole.atleta) const SizedBox(height: 16),

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

            // Grupos (solo admin y entrenador)
            if (userRole != UserRole.atleta)
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
            if (userRole != UserRole.atleta) const SizedBox(height: 16),

            // Ejercicios (solo admin y entrenador)
            if (userRole != UserRole.atleta)
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
            if (userRole != UserRole.atleta) const SizedBox(height: 16),

            // Planeaciones (todos)
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
