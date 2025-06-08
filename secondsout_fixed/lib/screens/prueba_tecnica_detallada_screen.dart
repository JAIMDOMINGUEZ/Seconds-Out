import 'package:flutter/material.dart';

class AgregarPruebaTecnicaScreen extends StatefulWidget {
  const AgregarPruebaTecnicaScreen({super.key});

  @override
  State<AgregarPruebaTecnicaScreen> createState() => _AgregarPruebaTecnicaScreenState();
}

class _AgregarPruebaTecnicaScreenState extends State<AgregarPruebaTecnicaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _distanciaGolpeo = 0;
  int _movilidad = 0;
  int _tecnicaDefensiva = 0;
  int _variabilidadDefensiva = 0;
  int _tecnicaGolpeo = 0;
  final List<int> _opciones = [0, 1, 2];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Técnica Detallada'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Icon(
                  Icons.circle_outlined, // Icono de gimnasio/ejercicio
                  size: 90,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),

              _buildDropdownItem(
                'Tecnica de Golpeo',
                _tecnicaGolpeo,
                    (value) => setState(() => _tecnicaGolpeo = value!),
              ),

              const SizedBox(height: 20),

              // Dropdown Distancia de Golpeo
              _buildDropdownItem(
                'Distancia de Golpeo',
                _distanciaGolpeo,
                    (value) => setState(() => _distanciaGolpeo = value!),
              ),
              const SizedBox(height: 20),

              // Dropdown Movilidad
              _buildDropdownItem(
                'Movilidad',
                _movilidad,
                    (value) => setState(() => _movilidad = value!),
              ),
              const SizedBox(height: 20),

              // Dropdown Técnica Defensiva
              _buildDropdownItem(
                'Técnica Defensiva',
                _tecnicaDefensiva,
                    (value) => setState(() => _tecnicaDefensiva = value!),
              ),
              const SizedBox(height: 20),

              // Dropdown Variabilidad Defensiva
              _buildDropdownItem(
                'Variabilidad Defensiva',
                _variabilidadDefensiva,
                    (value) => setState(() => _variabilidadDefensiva = value!),
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

  Widget _buildDropdownItem(String label, int value, Function(int?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: value,
            items: _opciones.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            validator: (value) {
              if (value == null) return 'Selecciona un valor';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

