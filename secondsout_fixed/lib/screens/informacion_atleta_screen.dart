import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/medidas_repository.dart';
import '../data/models/medidaantropometrica.dart';
import '../viewmodels/admin_medidas_view_model.dart';
import 'admin_medidas_screen.dart';
import 'admin_pruebas_screen.dart';
import 'agregar_pruebas_screen.dart' show AgregarPruebasScreen;

class InformacionAtletaScreen extends StatefulWidget {
  final Map<String, dynamic> atleta;

  const InformacionAtletaScreen({super.key, required this.atleta});

  @override
  State<InformacionAtletaScreen> createState() => _InformacionAtletaScreenState();
}

class _InformacionAtletaScreenState extends State<InformacionAtletaScreen> {
  MedidaAntropometrica? _medidaMasReciente;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarMedidaMasReciente();
  }

  Future<void> _cargarMedidaMasReciente() async {
    final repository = Provider.of<MedidasRepository>(context, listen: false);
    try {
      final medida = await repository.obtenerMedidaMasReciente(widget.atleta['idAtleta']);
      setState(() {
        _medidaMasReciente = medida;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error cargando medida: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pesoTexto = _medidaMasReciente != null ? '${_medidaMasReciente!.peso} kg' : 'No disponible';
    final tallaTexto = _medidaMasReciente != null ? '${_medidaMasReciente!.talla} cm' : 'No disponible';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Atleta'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Foto y nombre
            Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.atleta['nombre'] ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Información detallada con peso y talla de la medida más reciente
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildInfoRow('Peso', pesoTexto),
                    _buildInfoRow('Estatura', tallaTexto),
                    _buildInfoRow('Fecha de Nacimiento', widget.atleta['fechaNacimiento'] ?? 'No disponible'),
                    _buildInfoRow('Correo Electrónico', widget.atleta['email'] ?? 'No disponible'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botones
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => AdminMedidasViewModel(
                            Provider.of<MedidasRepository>(context, listen: false),
                          )..inicializar(widget.atleta['idAtleta']),
                          child: AdminMedidasScreen(atletaId: widget.atleta['idAtleta']),
                        ),
                      ),
                    );
                    await _cargarMedidaMasReciente();
                  },

                  icon: const Icon(Icons.straighten, color: Colors.black),
                  label: const Text(
                    'Administrar Medidas',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPruebasScreen(atletaId: widget.atleta['idAtleta']),
                      ),
                    );

                  },
                  icon: const Icon(Icons.assessment, color: Colors.black),
                  label: const Text(
                    'Administrar Pruebas',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
