import 'package:flutter/material.dart';

class EditarEjercicioScreen extends StatefulWidget {
  final Map<String, dynamic> ejercicio;

  const EditarEjercicioScreen({super.key, required this.ejercicio});

  @override
  State<EditarEjercicioScreen> createState() => _EditarEjercicioScreenState();
}

class _EditarEjercicioScreenState extends State<EditarEjercicioScreen> {
  late final _formKey = GlobalKey<FormState>();
  late final _nombreController = TextEditingController(text: widget.ejercicio['nombre']);
  late final _descripcionController = TextEditingController(text: widget.ejercicio['descripcion']);
  late String _tipoSeleccionado = widget.ejercicio['tipo'];

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
        title: const Text('Editar Ejercicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final ejercicioActualizado = {
                  'id': widget.ejercicio['id'],
                  'nombre': _nombreController.text,
                  'tipo': _tipoSeleccionado,
                  'descripcion': _descripcionController.text,
                };
                Navigator.pop(context, ejercicioActualizado);
              }
            },
          ),
        ],
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
            ],
          ),
        ),
      ),
    );
  }
}