import 'package:flutter/material.dart';

class EditarEjercicioScreen extends StatefulWidget {
  final Map<String, dynamic> ejercicio;

  const EditarEjercicioScreen({super.key, required this.ejercicio});

  @override
  State<EditarEjercicioScreen> createState() => _EditarEjercicioScreenState();
}

class _EditarEjercicioScreenState extends State<EditarEjercicioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late String _tipoSeleccionado;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.ejercicio['nombre']);
    _descripcionController = TextEditingController(text: widget.ejercicio['descripcion']);
    _tipoSeleccionado = widget.ejercicio['tipo'];
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _guardarEjercicio() {
    if (_formKey.currentState!.validate()) {
      final ejercicioActualizado = {
        'id_ejercicio': widget.ejercicio['id_ejercicio'],
        'nombre': _nombreController.text,
        'tipo': _tipoSeleccionado,
        'descripcion': _descripcionController.text,
      };
      Navigator.pop(context, ejercicioActualizado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ejercicio'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Guardar cambios',
            onPressed: _guardarEjercicio,
          ),
        ],
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

                  // Tipo de ejercicio
                  DropdownButtonFormField<String>(
                    value: _tipoSeleccionado,
                    decoration: InputDecoration(
                      labelText: 'Tipo de ejercicio',
                      floatingLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.category),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
