import 'package:flutter/material.dart';

class EditarPruebaScreen extends StatefulWidget {
  final Map<String, dynamic> prueba;
  final Function(Map<String, dynamic>) onGuardar;

  const EditarPruebaScreen({
    super.key,
    required this.prueba,
    required this.onGuardar,
  });

  @override
  State<EditarPruebaScreen> createState() => _EditarPruebaScreenState();
}

class _EditarPruebaScreenState extends State<EditarPruebaScreen> {
  late TextEditingController _fechaController;
  late String _estadoSeleccionado;
  final List<String> _opcionesEstado = ['BIEN', 'REGULAR', 'MAL'];

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(text: widget.prueba['fecha'] ?? '01/01/2000');
    _estadoSeleccionado = widget.prueba['estado'] ?? 'BIEN';
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prueba'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_fechaController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('La fecha no puede estar vacía')),
                );
                return;
              }

              final pruebaEditada = {
                'id': widget.prueba['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                'fecha': _fechaController.text,
                'estado': _estadoSeleccionado,
              };
              widget.onGuardar(pruebaEditada);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha (DD/MM/AA)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _estadoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: _opcionesEstado.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _estadoSeleccionado = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}