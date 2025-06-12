import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/ejercicio.dart';
import '../viewmodels/admin_ejercicios_view_model.dart';

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
    final viewModel = Provider.of<EjercicioViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Ejercicio'),
        centerTitle: true,
        leading: const Icon(Icons.fitness_center),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo Nombre
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del ejercicio',
                      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.text_fields),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Dropdown Tipo
                  DropdownButtonFormField<String>(
                    value: _tipoSeleccionado,
                    decoration: InputDecoration(
                      labelText: 'Tipo de ejercicio',
                      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: ['Boxeo', 'Acondicionamiento', 'Fuerza']
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
                  const SizedBox(height: 20),

                  // Descripción
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Botón Guardar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Ejercicio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final nuevoEjercicio = Ejercicio(
                            nombre: _nombreController.text,
                            tipo: _tipoSeleccionado,
                            descripcion: _descripcionController.text,
                          );

                          await viewModel.agregarEjercicio(nuevoEjercicio);

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ejercicio registrado'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
