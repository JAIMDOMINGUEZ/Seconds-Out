import 'package:flutter/material.dart';
import 'package:secondsout/data/models/prueba_tactica.dart';

class PruebaTacticaScreen extends StatefulWidget {
  final PruebaTactica? pruebaExistente;
  final Function(PruebaTactica) onGuardar;

  const PruebaTacticaScreen({
    super.key,
    this.pruebaExistente,
    required this.onGuardar,
  });

  @override
  State<PruebaTacticaScreen> createState() => _PruebaTacticaScreenState();
}

class _PruebaTacticaScreenState extends State<PruebaTacticaScreen> {
  final _formKey = GlobalKey<FormState>();
  int _distanciaCombate = 0;
  int _preparacionOfensiva = 0;
  int _eficienciaAtaque = 0;
  int _eficienciaContraataque = 0;
  int _entradaDistanciaCorta = 0;

  final List<int> _opciones = [0, 1, 2];

  @override
  void initState() {
    super.initState();
    if (widget.pruebaExistente != null) {
      _distanciaCombate = widget.pruebaExistente!.distanciaCombate;
      _preparacionOfensiva = widget.pruebaExistente!.preparacionOfensiva;
      _eficienciaAtaque = widget.pruebaExistente!.eficienciaAtaque;
      _eficienciaContraataque = widget.pruebaExistente!.eficienciaContraataque;
      _entradaDistanciaCorta = widget.pruebaExistente!.entradaDistanciaCorta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba Táctica'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono agregado al inicio del formulario
              Center(
                child: Icon(
                  Icons.adjust_rounded,// Icono de estrategia/táctica
                  size: 140,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              _buildDropdownItem('Distancia de combate', _distanciaCombate, (value) {
                setState(() => _distanciaCombate = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Preparación ofensiva', _preparacionOfensiva, (value) {
                setState(() => _preparacionOfensiva = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Eficiencia del ataque', _eficienciaAtaque, (value) {
                setState(() => _eficienciaAtaque = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Eficiencia del contraataque', _eficienciaContraataque, (value) {
                setState(() => _eficienciaContraataque = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Entrada a la distancia más corta', _entradaDistanciaCorta, (value) {
                setState(() => _entradaDistanciaCorta = value!);
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