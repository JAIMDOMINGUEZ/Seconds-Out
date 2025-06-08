import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarMedidaAntropometricaScreen extends StatefulWidget {
  final Map<String, dynamic> medidaExistente;
  final Function(Map<String, dynamic>) onGuardar;

  const EditarMedidaAntropometricaScreen({
    super.key,
    required this.medidaExistente,
    required this.onGuardar,
  });

  @override
  State<EditarMedidaAntropometricaScreen> createState() => _EditarMedidaAntropometricaScreenState();
}

class _EditarMedidaAntropometricaScreenState extends State<EditarMedidaAntropometricaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _tallaController = TextEditingController();
  final TextEditingController _somatotipoController = TextEditingController();
  final TextEditingController _imcController = TextEditingController()..text = '0.0';
  final TextEditingController _cinturaCaderaController = TextEditingController();
  final TextEditingController _seisPlieguesController = TextEditingController();
  final TextEditingController _ochoPlieguesController = TextEditingController();
  final TextEditingController _pGrasoController = TextEditingController();
  final TextEditingController _pMuscularController = TextEditingController();
  final TextEditingController _pOseoController = TextEditingController();

  DateTime _fecha = DateTime.now();
  final NumberFormat _numberFormat = NumberFormat.decimalPattern('es');

  @override
  void initState() {
    super.initState();
    _cargarDatosExistente();
    _pesoController.addListener(_calcularIMC);
    _tallaController.addListener(_calcularIMC);
  }

  void _cargarDatosExistente() {
    if (widget.medidaExistente != null) {
      _pesoController.text = _numberFormat.format(widget.medidaExistente!['peso'] ?? 0.0);
      _tallaController.text = _numberFormat.format(widget.medidaExistente!['talla'] ?? 0.0);
      _somatotipoController.text = widget.medidaExistente!['somatotipo'] ?? '';
      _imcController.text = _numberFormat.format(widget.medidaExistente!['imc'] ?? 0.0);
      _cinturaCaderaController.text = _numberFormat.format(widget.medidaExistente!['cintura_cadera'] ?? 0.0);
      _seisPlieguesController.text = _numberFormat.format(widget.medidaExistente!['seis_pliegues'] ?? 0.0);
      _ochoPlieguesController.text = _numberFormat.format(widget.medidaExistente!['ocho_pliegues'] ?? 0.0);
      _pGrasoController.text = _numberFormat.format(widget.medidaExistente!['p_graso'] ?? 0.0);
      _pMuscularController.text = _numberFormat.format(widget.medidaExistente!['p_muscular'] ?? 0.0);
      _pOseoController.text = _numberFormat.format(widget.medidaExistente!['p_oseo'] ?? 0.0);

      if (widget.medidaExistente!['fecha'] != null) {
        _fecha = DateTime.parse(widget.medidaExistente!['fecha']);
      }
    }
  }

  void _calcularIMC() {
    if (_pesoController.text.isNotEmpty && _tallaController.text.isNotEmpty) {
      try {
        double peso = double.parse(_pesoController.text.replaceAll(',', '.'));
        double talla = double.parse(_tallaController.text.replaceAll(',', '.')) / 100;

        if (talla > 0) {
          double imc = peso / (talla * talla);
          _imcController.text = imc.toStringAsFixed(2);
        }
      } catch (e) {
        _imcController.text = '0.0';
      }
    } else {
      _imcController.text = '0.0';
    }
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fecha) {
      setState(() {
        _fecha = picked;
      });
    }
  }

  @override
  void dispose() {
    _pesoController.removeListener(_calcularIMC);
    _tallaController.removeListener(_calcularIMC);
    _pesoController.dispose();
    _tallaController.dispose();
    _somatotipoController.dispose();
    _imcController.dispose();
    _cinturaCaderaController.dispose();
    _seisPlieguesController.dispose();
    _ochoPlieguesController.dispose();
    _pGrasoController.dispose();
    _pMuscularController.dispose();
    _pOseoController.dispose();
    super.dispose();
  }

  void _guardarMedidas() {
    if (_formKey.currentState!.validate()) {
      final medidas = {
        'peso': double.tryParse(_pesoController.text.replaceAll(',', '.')) ?? 0.0,
        'talla': double.tryParse(_tallaController.text.replaceAll(',', '.')) ?? 0.0,
        'somatotipo': _somatotipoController.text,
        'imc': double.tryParse(_imcController.text.replaceAll(',', '.')) ?? 0.0,
        'cintura_cadera': double.tryParse(_cinturaCaderaController.text.replaceAll(',', '.')) ?? 0.0,
        'seis_pliegues': double.tryParse(_seisPlieguesController.text.replaceAll(',', '.')) ?? 0.0,
        'ocho_pliegues': double.tryParse(_ochoPlieguesController.text.replaceAll(',', '.')) ?? 0.0,
        'p_graso': double.tryParse(_pGrasoController.text.replaceAll(',', '.')) ?? 0.0,
        'p_muscular': double.tryParse(_pMuscularController.text.replaceAll(',', '.')) ?? 0.0,
        'p_oseo': double.tryParse(_pOseoController.text.replaceAll(',', '.')) ?? 0.0,
        'fecha': _fecha.toIso8601String(),
      };

      widget.onGuardar(medidas);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Medidas Antropométricas'),
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
                  Icons.accessibility_new,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _buildNumberFormField(
                      label: 'Peso (kg)',
                      controller: _pesoController,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberFormField(
                      label: 'Talla (cm)',
                      controller: _tallaController,
                      isRequired: true,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _imcController,
                  decoration: const InputDecoration(
                    labelText: 'IMC (Calculado automáticamente)',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.number,
                ),
              ),

              _buildTextFormField(
                label: 'Somatotipo',
                controller: _somatotipoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el somatotipo';
                  }
                  return null;
                },
              ),

              _buildNumberFormField(
                label: 'Relación Cintura/Cadera',
                controller: _cinturaCaderaController,
              ),

              _buildNumberFormField(
                label: '6 Pliegues (mm)',
                controller: _seisPlieguesController,
              ),

              _buildNumberFormField(
                label: '8 Pliegues (mm)',
                controller: _ochoPlieguesController,
              ),

              _buildNumberFormField(
                label: '% Graso',
                controller: _pGrasoController,
              ),

              _buildNumberFormField(
                label: '% Muscular',
                controller: _pMuscularController,
              ),

              _buildNumberFormField(
                label: '% Óseo',
                controller: _pOseoController,
              ),

              InkWell(
                onTap: () => _seleccionarFecha(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_fecha)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarMedidas,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Guardar Cambios'),
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

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildNumberFormField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: isRequired
            ? (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es requerido';
          }
          if (double.tryParse(value.replaceAll(',', '.')) == null) {
            return 'Ingrese un número válido';
          }
          return null;
        }
            : null,
      ),
    );
  }
}