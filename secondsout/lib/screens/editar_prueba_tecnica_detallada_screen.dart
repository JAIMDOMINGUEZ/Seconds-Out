import 'package:flutter/material.dart';

class EditarPruebaTecnicaDetalladaScreen extends StatefulWidget {
  final Map<String, dynamic>? pruebaExistente;
  final Function(Map<String, dynamic>) onGuardar;

  const EditarPruebaTecnicaDetalladaScreen({
    super.key,
    this.pruebaExistente,
    required this.onGuardar,
  });

  @override
  State<EditarPruebaTecnicaDetalladaScreen> createState() => _EditarPruebaTecnicaDetalladaScreenState();
}

class _EditarPruebaTecnicaDetalladaScreenState extends State<EditarPruebaTecnicaDetalladaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _distanciaGolpeo = 0;
  int _movilidad = 0;
  int _tecnicaDefensiva = 0;
  int _variabilidadDefensiva = 0;
  int _tecnicaGolpeo = 0;
  final List<int> _opciones = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    if (widget.pruebaExistente != null) {
      _distanciaGolpeo = _safeParseInt(widget.pruebaExistente?['distanciaGolpeo']);
      _movilidad = _safeParseInt(widget.pruebaExistente?['movilidad']);
      _tecnicaDefensiva = _safeParseInt(widget.pruebaExistente?['tecnicaDefensiva']);
      _variabilidadDefensiva = _safeParseInt(widget.pruebaExistente?['variabilidadDefensiva']);
      _tecnicaGolpeo = _safeParseInt(widget.pruebaExistente?['tecnicaGolpeo']);
    }
  }

  int _safeParseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prueba Técnica Detallada'),
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
                  Icons.circle_outlined,
                  size: 90,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              _buildDropdownItem(
                'Técnica de Golpeo',
                _tecnicaGolpeo,
                    (value) => setState(() => _tecnicaGolpeo = value!),
              ),

              const SizedBox(height: 20),

              _buildDropdownItem(
                'Distancia de Golpeo',
                _distanciaGolpeo,
                    (value) => setState(() => _distanciaGolpeo = value!),
              ),

              const SizedBox(height: 20),

              _buildDropdownItem(
                'Movilidad',
                _movilidad,
                    (value) => setState(() => _movilidad = value!),
              ),

              const SizedBox(height: 20),

              _buildDropdownItem(
                'Técnica Defensiva',
                _tecnicaDefensiva,
                    (value) => setState(() => _tecnicaDefensiva = value!),
              ),

              const SizedBox(height: 20),

              _buildDropdownItem(
                'Variabilidad Defensiva',
                _variabilidadDefensiva,
                    (value) => setState(() => _variabilidadDefensiva = value!),
              ),

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

  void _guardarPrueba() {
    if (_formKey.currentState!.validate()) {
      final pruebaActualizada = {
        'tipo': 'Tecnica Detallada',
        'puntaje': _calcularPuntajeTotal(),
        'detalles': {
          'distanciaGolpeo': _distanciaGolpeo,
          'movilidad': _movilidad,
          'tecnicaDefensiva': _tecnicaDefensiva,
          'variabilidadDefensiva': _variabilidadDefensiva,
          'tecnicaGolpeo': _tecnicaGolpeo,
        },
      };

      widget.onGuardar(pruebaActualizada);
      Navigator.pop(context);
    }
  }

  int _calcularPuntajeTotal() {
    return _distanciaGolpeo +
        _movilidad +
        _tecnicaDefensiva +
        _variabilidadDefensiva +
        _tecnicaGolpeo;
  }
}