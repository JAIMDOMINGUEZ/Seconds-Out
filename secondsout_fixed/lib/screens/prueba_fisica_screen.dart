import 'package:flutter/material.dart';
import '../viewmodels/admin_prueba_fisica_view_model.dart';
import '/data/models/prueba_fisica.dart';
import '/repositories/prueba_fisica_repository.dart';
import '/viewmodels/admin_prueba_fisica_view_model.dart';

class PruebaFisicaScreen extends StatefulWidget {
  final int? idPrueba;

  const PruebaFisicaScreen({
    super.key,
    this.idPrueba,
  });

  @override
  State<PruebaFisicaScreen> createState() => _PruebaFisicaScreenState();
}

class _PruebaFisicaScreenState extends State<PruebaFisicaScreen> {
  final _formKey = GlobalKey<FormState>();

  late PruebaFisicaViewModel viewModel;

  int _rapidez = 0;
  int _fuerza = 0;
  int _reaccion = 0;
  int _explosividad = 0;
  int _coordinacion = 0;
  int _resistencia = 0;

  final List<int> _opciones = List.generate(3, (index) => index); // 0-10

  @override
  void initState() {
    super.initState();
    // Instanciar viewModel con el repositorio
    viewModel = PruebaFisicaViewModel(repository: PruebaFisicaRepository());
  }

  Future<void> _guardarPrueba() async {
    final prueba = PruebaFisica.conPuntajeCalculado(
      id_prueba: widget.idPrueba ?? 0,
      //id_prueba_fisica: null, // null para nueva inserción autogenerada
      resistencia: _resistencia,
      rapidez: _rapidez,
      fuerza: _fuerza,
      reaccion: _reaccion,
      explosividad: _explosividad,
      coordinacion: _coordinacion,
    );

    final success = await viewModel.guardarPrueba(prueba);
    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba física'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.fitness_center, size: 90, color: Colors.black),
              const SizedBox(height: 20),
              _buildDropdownItem('Resistencia', _resistencia, (v) => setState(() => _resistencia = v!)),
              const SizedBox(height: 20),
              _buildDropdownItem('Rapidez', _rapidez, (v) => setState(() => _rapidez = v!)),
              const SizedBox(height: 20),
              _buildDropdownItem('Fuerza', _fuerza, (v) => setState(() => _fuerza = v!)),
              const SizedBox(height: 20),
              _buildDropdownItem('Reacción', _reaccion, (v) => setState(() => _reaccion = v!)),
              const SizedBox(height: 20),
              _buildDropdownItem('Explosividad', _explosividad, (v) => setState(() => _explosividad = v!)),
              const SizedBox(height: 20),
              _buildDropdownItem('Coordinación', _coordinacion, (v) => setState(() => _coordinacion = v!)),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarPrueba,
                      child: const Text('Guardar'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildDropdownItem(String label, int value, ValueChanged<int?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        DropdownButtonFormField<int>(
          value: value,
          items: _opciones.map((v) {
            return DropdownMenuItem<int>(
              value: v,
              child: Text('$v'),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (value) {
            if (value == null) return 'Seleccione un valor';
            return null;
          },
        ),
      ],
    );
  }
}
