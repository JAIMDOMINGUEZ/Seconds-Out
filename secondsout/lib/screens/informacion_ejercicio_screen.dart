import 'package:flutter/material.dart';

class InformacionEjercicioScreen extends StatelessWidget {
  final Map<String, dynamic> ejercicio;

  const InformacionEjercicioScreen({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Ejercicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForExerciseType(ejercicio['tipo']),
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              ejercicio['nombre'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo: ${ejercicio['tipo']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ejercicio['descripcion'],
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForExerciseType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'boxeo':
        return Icons.sports_mma;
      case 'acondicionamiento':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }
}