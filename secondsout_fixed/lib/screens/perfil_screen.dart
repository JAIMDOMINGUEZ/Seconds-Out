import 'package:flutter/material.dart';
import 'admin_medidas_screen.dart';
import 'admin_pruebas_screen.dart';

class PerfilScreen extends StatelessWidget {
  final bool isAthlete;
  final Map<String, dynamic> usuario;

  const PerfilScreen({
    super.key,
    required this.isAthlete,
    this.usuario = const {
      'nombre': 'Oliver Garcia',
      'peso': '64',
      'estatura': '1.73',
      'fechaNacimiento': '08/01/2001',
      'email': 'oliveerg@gmail.com',
      'fotoUrl': 'https://randomuser.me/api/portraits/men/1.jpg',
      'id': '1'
    },
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAthlete ? 'Perfil Atleta' : 'Perfil Entrenador'),
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
            const SizedBox(height: 20),

            // Foto y nombre principal (común para ambos)
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: usuario['fotoUrl'] != null
                        ? NetworkImage(usuario['fotoUrl']) as ImageProvider
                        : null,
                    child: usuario['fotoUrl'] == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    usuario['nombre'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Información básica (común para ambos)
            _buildInfoRow('Correo Electrónico', usuario['email']),
            _buildInfoRow('Fecha de Nacimiento', usuario['fechaNacimiento']),

            // Información adicional solo para atletas
            if (isAthlete) ...[
              _buildInfoRow('Peso', '${usuario['peso']}kg'),
              _buildInfoRow('Estatura', '${usuario['estatura']}m'),
              const SizedBox(height: 20),
            ],



            // Botones específicos para atletas
            if (isAthlete) ...[
              ElevatedButton(
                onPressed: () {
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminMedidasScreen(
                        medidas: usuario['medidas'] ?? [],
                      ),
                    ),
                  );*/
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                ),
                child: const Text('Mis Medidas'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPruebasScreen(
                        atletaId: usuario['id'],
                        nombreAtleta: usuario['nombre'],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                ),
                child: const Text('Mis Pruebas'),
              ),
              const SizedBox(height: 16),
            ],



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
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}