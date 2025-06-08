import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/atleta.dart';
import '../viewmodels/admin_medidas_view_model.dart';
import 'admin_medidas_screen.dart'; // Importa tu modelo Atleta

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
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    atleta['nombre'] ?? 'Sin nombre',
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
            _buildInfoRow('Peso', '${atleta['peso'] ?? 'No disponible'} kg'),
            _buildInfoRow('Estatura', '${atleta['estatura'] ?? 'No disponible'} m'),
            _buildInfoRow('Fecha de Nacimiento', atleta['fechaNacimiento'] ?? 'No disponible'),
            _buildInfoRow('Correo Electrónico', atleta['email'] ?? 'No disponible'),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminMedidasScreen(
                      atletaId: atleta['idAtleta'], // Pasa el ID del atleta
                    ),
                  ),
                );
              },


              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,

              ),
              child: const Text('Administrar Medidas'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPruebasScreen(
                      atletaId: atleta.id,
                      nombreAtleta: atleta.nombre,
                    ),
                  ),
                );*/
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
              ),
              child: const Text('Administrar Pruebas'),
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
            width: 150,
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
