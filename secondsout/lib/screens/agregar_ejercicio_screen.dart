import 'package:flutter/material.dart';

class RegistrarEjercicioScreen extends StatefulWidget {
  const RegistrarEjercicioScreen({super.key});

  @override
  State<RegistrarEjercicioScreen> createState() => _RegistrarEjercicioScreenState();
}

class _RegistrarEjercicioScreenState extends State<RegistrarEjercicioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  String _tipoSeleccionado = 'Boxeo';

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Ejercicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del ejercicio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de ejercicio',
                  border: OutlineInputBorder(),
                ),
                items: ['Boxeo', 'Acondicionamiento', 'Técnica', 'Fuerza']
                    .map((tipo) => DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoSeleccionado = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevoEjercicio = {
                      'nombre': _nombreController.text,
                      'tipo': _tipoSeleccionado,
                      'descripcion': _descripcionController.text,
                    };
                    Navigator.pop(context, nuevoEjercicio);
                  }
                },
                child: const Text('Guardar Ejercicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}