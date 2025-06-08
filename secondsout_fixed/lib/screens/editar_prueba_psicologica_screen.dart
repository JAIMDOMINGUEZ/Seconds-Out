import 'package:flutter/material.dart';
import '/data/models/prueba_psicologica.dart';

class EditarPruebaPsicologicaScreen extends StatefulWidget {
  final PruebaPsicologica? pruebaExistente;
  final Function(PruebaPsicologica) onGuardar;

  const EditarPruebaPsicologicaScreen({
    super.key,
    this.pruebaExistente,
    required this.onGuardar,
  });

  @override
  State<EditarPruebaPsicologicaScreen> createState() => _EditarPruebaPsicologicaScreenState();
}

class _EditarPruebaPsicologicaScreenState extends State<EditarPruebaPsicologicaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _autocontrol = 0;
  int _combatividad = 0;
  int _iniciativa = 0;

  final List<int> _opciones = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    if (widget.pruebaExistente != null) {
      _autocontrol = widget.pruebaExistente!.autocontrol;
      _combatividad = widget.pruebaExistente!.combatividad;
      _iniciativa = widget.pruebaExistente!.iniciativa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prueba Psicológica'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono de psicología
              Center(
                child: Icon(
                  Icons.psychology, // Icono de psicología
                  size: 90,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              _buildDropdownItem('Autocontrol', _autocontrol, (value) {
                setState(() => _autocontrol = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Combatividad', _combatividad, (value) {
                setState(() => _combatividad = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Iniciativa', _iniciativa, (value) {
                setState(() => _iniciativa = value!);
              }),

              const SizedBox(height: 40),

              // Botones Guardar y Cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarPrueba,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
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
    return Column(
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
    );
  }

  void _guardarPrueba() {

      Navigator.pop(context);

  }
}