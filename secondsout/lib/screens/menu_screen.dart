import 'package:flutter/material.dart';
import 'package:secondsout/screens/admin_entrenadores_screen.dart';

import 'admin_atletas_screen.dart';
import 'admin_ejercicios_screen.dart';
import 'admin_planeacion_screen.dart';
import 'agregar_ejercicio_screen.dart'; // Si están en la misma carpeta
void main() {
  runApp(const MenuApp());
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/1.jpg'), // Imagen temporal
              radius: 18,
            ),
            onPressed: () {
              // Acción para el perfil del usuario
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
            _buildMenuOption(
              context,
              icon: Icons.people, // Icono provisional para Atletas
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            _buildMenuOption(
              context,
              icon: Icons.group, // Icono provisional para Grupos
              title: 'Grupos',
              onTap: () {
                // Navegar a pantalla de Grupos
              },
            ),
            const SizedBox(height: 16),
            _buildMenuOption(
              context,
              icon: Icons.fitness_center, // Icono provisional para Ejercicios
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
            const SizedBox(height: 16),
            _buildMenuOption(
              context,
              icon: Icons.calendar_today, // Icono provisional para Planeaciones
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