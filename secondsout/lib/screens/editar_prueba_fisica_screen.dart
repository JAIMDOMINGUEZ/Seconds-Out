import 'package:flutter/material.dart';
import 'package:secondsout/data/models/prueba_fisica.dart';

class EditarPruebaFisicaScreen extends StatefulWidget {
  final PruebaFisica? pruebaExistente;
  final Function(PruebaFisica) onGuardar;

  const EditarPruebaFisicaScreen({
    super.key,
    this.pruebaExistente,
    required this.onGuardar,
  });

  @override
  State<EditarPruebaFisicaScreen> createState() => _EditarPruebaFisicaScreenState();
}

class _EditarPruebaFisicaScreenState extends State<EditarPruebaFisicaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rapidez = 0;
  int _fuerza = 0;
  int _reaccion = 0;
  int _explosividad = 0;
  int _coordinacion = 0;

  final List<int> _opciones = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    if (widget.pruebaExistente != null) {
      _rapidez = widget.pruebaExistente?.rapidez ?? 0;
      _fuerza = widget.pruebaExistente?.fuerza ?? 0;
      _reaccion = widget.pruebaExistente?.reaccion ?? 0;
      _explosividad = widget.pruebaExistente?.explosividad ?? 0;
      _coordinacion = widget.pruebaExistente?.coordinacion ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prueba Física'),
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
                  Icons.fitness_center,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              _buildDropdownItem('Rapidez', _rapidez, (value) {
                setState(() => _rapidez = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Fuerza', _fuerza, (value) {
                setState(() => _fuerza = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Reacción', _reaccion, (value) {
                setState(() => _reaccion = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Explosividad', _explosividad, (value) {
                setState(() => _explosividad = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Coordinación', _coordinacion, (value) {
                setState(() => _coordinacion = value!);
              }),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarPrueba,
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