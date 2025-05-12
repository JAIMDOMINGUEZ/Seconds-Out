import 'package:flutter/material.dart';
import 'package:secondsout/data/models/pruebas_regla.dart';

class PruebaReglasScreen extends StatefulWidget {
  final PruebaReglas? pruebaExistente;
  final Function(PruebaReglas) onGuardar;

  const PruebaReglasScreen({
    super.key,
    this.pruebaExistente,
    required this.onGuardar,
  });

  @override
  State<PruebaReglasScreen> createState() => _PruebaReglasScreenState();
}

class _PruebaReglasScreenState extends State<PruebaReglasScreen> {
  final _formKey = GlobalKey<FormState>();
  int _faltasTecnicas = 0;
  int _conductaCombativa = 0;

  final List<int> _opciones = [0, 1, 2]; // Escala de 0 a 2

  @override
  void initState() {
    super.initState();
    if (widget.pruebaExistente != null) {
      _faltasTecnicas = widget.pruebaExistente!.faltasTecnicas;
      _conductaCombativa = widget.pruebaExistente!.conductaCombativa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Reglas'),
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
                  Icons.check_circle_outline,
                  size: 90,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              _buildDropdownItem('Faltas técnicas', _faltasTecnicas, (value) {
                setState(() => _faltasTecnicas = value!);
              }),

              const SizedBox(height: 20),

              _buildDropdownItem('Conducta combativa', _conductaCombativa, (value) {
                setState(() => _conductaCombativa = value!);
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
                        side: BorderSide(color: Colors.black!),
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