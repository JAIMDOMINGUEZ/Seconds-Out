import 'package:flutter/material.dart';

class AgregarPruebaTecnicaScreen extends StatefulWidget {
  const AgregarPruebaTecnicaScreen({super.key});

  @override
  State<AgregarPruebaTecnicaScreen> createState() => _AgregarPruebaTecnicaScreenState();
}

class _AgregarPruebaTecnicaScreenState extends State<AgregarPruebaTecnicaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _movilidadController = TextEditingController();
  final TextEditingController _tecnicaDefensivaController = TextEditingController();
  final TextEditingController _variabilidadController = TextEditingController();

  @override
  void dispose() {
    _distanciaController.dispose();
    _movilidadController.dispose();
    _tecnicaDefensivaController.dispose();
    _variabilidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Prueba Tecnicaaa'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '9:41',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Prueba Tecnica Detalladaaa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 2),
              const SizedBox(height: 20),

              const Text(
                'Tecnica de Golpeoa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Campo Distancia de Golpeo
              TextFormField(
                controller: _distanciaController,
                decoration: const InputDecoration(
                  labelText: 'Distancia de Golpeo',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la distancia de golpeo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese este dato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Movilidad
              TextFormField(
                controller: _movilidadController,
                decoration: const InputDecoration(
                  labelText: 'Movilidad',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese los datos de movilidad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese este dato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Tecnica Defensiva
              TextFormField(
                controller: _tecnicaDefensivaController,
                decoration: const InputDecoration(
                  labelText: 'Tecnica Defensiva',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la técnica defensiva',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese este dato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo Variabilidad Defensiva
              TextFormField(
                controller: _variabilidadController,
                decoration: const InputDecoration(
                  labelText: 'Variabilidad Defensiva',
                  border: OutlineInputBorder(),
                  hintText: 'Ingrese la variabilidad defensiva',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese este dato';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botones Guardar y Cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Procesar el formulario
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Prueba técnica guardada exitosamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Guardar'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AgregarPruebaTecnicaScreen(),
  ));
}