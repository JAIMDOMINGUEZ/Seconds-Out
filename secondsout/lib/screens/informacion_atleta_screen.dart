import 'package:flutter/material.dart';
import 'admin_medidas_screen.dart';
import 'admin_pruebas_screen.dart'; // Asegúrate de crear este archivo

class InformacionAtletaScreen extends StatelessWidget {
  final Map<String, dynamic> atleta;

  const InformacionAtletaScreen({super.key, required this.atleta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Atleta'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '9:41',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 30),

            // Foto y nombre principal
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: atleta['fotoUrl'] != null
                        ? NetworkImage(atleta['fotoUrl']) as ImageProvider
                        : null,
                    child: atleta['fotoUrl'] == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    atleta['nombre'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Datos del atleta
            _buildInfoRow('Peso', '${atleta['peso'] ?? '6.4'}kg'),
            _buildInfoRow('Estatura', '${atleta['estatura'] ?? '1.73'}m'),
            _buildInfoRow('Fecha de Nacimiento', atleta['fechaNacimiento']),
            _buildInfoRow('Correo Electrónico', atleta['email']),

            const SizedBox(height: 40),


            ElevatedButton(
              onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AdminMedidasScreen(
    medidas: atleta['medidas'] ?? [], // Asegúrate que atleta tenga este campo
    ),
    ),
    );

              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
              ),
              child: const Text('Administrar Medidas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPruebasScreen(
                      atletaId: atleta['id'],
                      nombreAtleta: atleta['nombre'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black,
              ),
              child: const Text('Administrar Pruebas'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.grey), // Borde visible
              ),
              child: const Text(
                'Volver',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 150, // Ancho fijo para alinear los valores
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

