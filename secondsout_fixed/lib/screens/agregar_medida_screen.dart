import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/viewmodels/admin_medidas_view_model.dart';
import '../data/models/medidaantropometrica.dart';

class MedidaAntropometricaScreen extends StatefulWidget {
  final int atletaId;
  final AdminMedidasViewModel viewModel;

  const MedidaAntropometricaScreen({
    super.key,
    required this.atletaId,
    required this.viewModel,
  });

  @override
  State<MedidaAntropometricaScreen> createState() => _MedidaAntropometricaScreenState();
}

class _MedidaAntropometricaScreenState extends State<MedidaAntropometricaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _tallaController = TextEditingController();
  final _somatotipoController = TextEditingController();
  final _imcController = TextEditingController()..text = '0.0';
  final _cinturaCaderaController = TextEditingController();
  final _seisPlieguesController = TextEditingController();
  final _ochoPlieguesController = TextEditingController();
  final _porcentajeGrasoController = TextEditingController();
  final _porcentajeMuscularController = TextEditingController();
  final _porcentajeOseoController = TextEditingController();

  DateTime _fecha = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _pesoController.addListener(_calcularIMC);
    _tallaController.addListener(_calcularIMC);
  }

  void _calcularIMC() {
    if (_pesoController.text.isNotEmpty && _tallaController.text.isNotEmpty) {
      try {
        final peso = double.parse(_pesoController.text);
        final talla = double.parse(_tallaController.text) / 100; // Convertir cm a m

        if (talla > 0) {
          final imc = peso / (talla * talla);
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fecha) {
      setState(() => _fecha = picked);
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
    _porcentajeGrasoController.dispose();
    _porcentajeMuscularController.dispose();
    _porcentajeOseoController.dispose();
    super.dispose();
  }

  Future<void> _guardarMedidas() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final medida = MedidaAntropometrica(
        idMedida: 0,
        idAtleta: widget.atletaId,
        fecha: _fecha,
        peso: double.tryParse(_pesoController.text) ?? 0.0,
        talla: double.tryParse(_tallaController.text) ?? 0.0,
        somatotipo: _somatotipoController.text,
        imc: double.tryParse(_imcController.text) ?? 0.0,
        cinturaCadera: double.tryParse(_cinturaCaderaController.text),
        seisPliegues: double.tryParse(_seisPlieguesController.text),
        ochoPliegues: double.tryParse(_ochoPlieguesController.text),
        porcentajeGraso: double.tryParse(_porcentajeGrasoController.text),
        porcentajeMuscular: double.tryParse(_porcentajeMuscularController.text),
        porcentajeOseo: double.tryParse(_porcentajeOseoController.text),
      );

      final success = await widget.viewModel.agregarMedida(medida);
      if (success && mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medidas Antropométricas'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
              _buildPesoTallaFields(),
              _buildIMCField(),
              _buildSomatotipoField(),
              _buildOptionalFields(),
              _buildFechaField(),
              const SizedBox(height: 40),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPesoTallaFields() {
    return Row(
      children: [
        Expanded(child: _buildNumberFormField('Peso (kg)*', _pesoController, true)),
        const SizedBox(width: 10),
        Expanded(child: _buildNumberFormField('Talla (cm)*', _tallaController, true)),
      ],
    );
  }

  Widget _buildIMCField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _imcController,
        decoration: const InputDecoration(
          labelText: 'IMC (Calculado automáticamente)',
          border: OutlineInputBorder(),
        ),
        readOnly: true,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildSomatotipoField() {
    return _buildTextFormField(
      'Somatotipo*',
      _somatotipoController,
          (value) => value?.isEmpty ?? true ? 'Ingrese el somatotipo' : null,
    );
  }

  Widget _buildOptionalFields() {
    return Column(
      children: [
        _buildNumberFormField('Relación Cintura/Cadera', _cinturaCaderaController),
        _buildNumberFormField('6 Pliegues (mm)', _seisPlieguesController),
        _buildNumberFormField('8 Pliegues (mm)', _ochoPlieguesController),
        _buildNumberFormField('% Graso', _porcentajeGrasoController),
        _buildNumberFormField('% Muscular', _porcentajeMuscularController),
        _buildNumberFormField('% Óseo', _porcentajeOseoController),
      ],
    );
  }

  Widget _buildFechaField() {
    return InkWell(
      onTap: () => _seleccionarFecha(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha*',
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
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isSaving ? null : _guardarMedidas,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: _isSaving
                ? const CircularProgressIndicator()
                : const Text('Guardar'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: OutlinedButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Cancelar'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
      String label,
      TextEditingController controller,
      String? Function(String?) validator,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: validator,
      ),
    );
  }

  Widget _buildNumberFormField(
      String label,
      TextEditingController controller,
      [bool isRequired = false]
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: isRequired
            ? (value) {
          if (value?.isEmpty ?? true) return 'Este campo es requerido';
          if (double.tryParse(value!) == null) return 'Ingrese un número válido';
          return null;
        }
            : null,
      ),
    );
  }
}