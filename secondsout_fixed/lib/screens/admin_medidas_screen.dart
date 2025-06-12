import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../data/models/medidaantropometrica.dart';
import '../viewmodels/admin_medidas_view_model.dart';
import 'agregar_medida_screen.dart';
import 'editar_medida_screen.dart';

class AdminMedidasScreen extends StatefulWidget {
  final int atletaId;

  const AdminMedidasScreen({super.key, required this.atletaId});

  @override
  State<AdminMedidasScreen> createState() => _AdminMedidasScreenState();
}

class _AdminMedidasScreenState extends State<AdminMedidasScreen> {
  String _selectedChart = 'IMC';
  final List<String> _chartOptions = [
    'IMC',
    '% Graso',
    '% Muscular',
    '% Óseo',
    'Peso',
    'Talla'
  ];
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<AdminMedidasViewModel>(context, listen: false);

    if (widget.atletaId == null) {
      print('Error: atletaId es nulo en la pantalla');
      return;
    }

    if (viewModel.atletaId != widget.atletaId) {
      viewModel.inicializar(widget.atletaId);
    }
  }
/*
  void _cargarMedidas() {
    final viewModel = Provider.of<AdminMedidasViewModel>(context, listen: false);
    viewModel.cargarMedidas();
  }*/

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _eliminarMedida(int idMedida, AdminMedidasViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Eliminar esta medición?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.eliminarMedida(idMedida).then((_) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Medición eliminada')),
                );
              });
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _agregarNuevaMedida(AdminMedidasViewModel viewModel) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedidaAntropometricaScreen(
          atletaId: widget.atletaId,
          viewModel: Provider.of<AdminMedidasViewModel>(context, listen: false),
        ),
      ),
    );

    // Recargar después de volver
    viewModel.cargarMedidas();
  }


  List<ChartData> _getChartData(List<MedidaAntropometrica> medidas) {
    return medidas.map((medida) {
      double value;
      switch (_selectedChart) {
        case 'IMC':
          value = medida.imc;
          break;
        case '% Graso':
          value = medida.porcentajeGraso ?? 0;
          break;
        case '% Muscular':
          value = medida.porcentajeMuscular ?? 0;
          break;
        case '% Óseo':
          value = medida.porcentajeOseo ?? 0;
          break;
        case 'Peso':
          value = medida.peso;
          break;
        case 'Talla':
          value = medida.talla;
          break;
        default:
          value = 0.0;
      }

      return ChartData(
        DateFormat('dd/MM/yy').format(medida.fecha),
        value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminMedidasViewModel>(
      builder: (context, viewModel, child) {
        final medidas = viewModel.medidas;
        final filteredMedidas = _searchController.text.isEmpty
            ? medidas
            : medidas.where((m) {
          final query = _searchController.text.toLowerCase();
          return DateFormat('dd/MM/yyyy').format(m.fecha).toLowerCase().contains(query) ||
              m.peso.toString().contains(query) ||
              m.talla.toString().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Historial de Medidas'),
            centerTitle: true,
            actions: [
              if (viewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Buscar por fecha, peso o talla...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(text: 'Evolución de $_selectedChart'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                      dataSource: _getChartData(filteredMedidas),
                      xValueMapper: (ChartData data, _) => data.fecha,
                      yValueMapper: (ChartData data, _) => data.valor,
                      name: _selectedChart,
                      markerSettings: const MarkerSettings(isVisible: true),
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: _selectedChart,
                  isExpanded: true,
                  items: _chartOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedChart = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildMedidasList(viewModel, filteredMedidas),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _agregarNuevaMedida(viewModel),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Agregar',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ),

        );
      },
    );
  }

  Widget _buildMedidasList(AdminMedidasViewModel viewModel, List<MedidaAntropometrica> medidas) {
    if (viewModel.isLoading && medidas.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (medidas.isEmpty) {
      return const Center(
        child: Text(
          'No hay medidas registradas',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.cargarMedidas(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80), // espacio para el FAB
        child: ListView.builder(
          itemCount: medidas.length,
          itemBuilder: (context, index) {
            final medida = medidas[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.assessment, color: Colors.blue),
                title: Text(
                  DateFormat('dd/MM/yyyy').format(medida.fecha),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peso: ${medida.peso.toStringAsFixed(2)} kg'),
                    Text('Talla: ${medida.talla.toStringAsFixed(2)} cm'),
                    Text('IMC: ${medida.imc.toStringAsFixed(2)}'),
                    Text('% Graso: ${medida.porcentajeGraso?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('% Muscular: ${medida.porcentajeMuscular?.toStringAsFixed(2) ?? 'N/A'}'),
                    Text('% Óseo: ${medida.porcentajeOseo?.toStringAsFixed(2) ?? 'N/A'}'),

                  ],

                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editarMedida(medida, viewModel),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarMedida(medida.idMedida, viewModel),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

  }

  void _editarMedida(MedidaAntropometrica medida, AdminMedidasViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarMedidaAntropometricaScreen(
          medidaExistente: medida.toLocalMapForUpdate(), // convierte objeto a Map
          onGuardar: (Map<String, dynamic> medidaActualizadaMap) async {
            try {
              print('Datos recibidos en onGuardar: $medidaActualizadaMap');

              // Validamos que venga id_medida, si no, lo asignamos desde el objeto original
              if (!medidaActualizadaMap.containsKey('id_medida') || medidaActualizadaMap['id_medida'] == null) {
                medidaActualizadaMap['id_medida'] = medida.idMedida;
                print('Se agregó id_medida desde el objeto original: ${medida.idMedida}');
              }

              final medidaActualizadaObj = MedidaAntropometrica.fromLocalMap(medidaActualizadaMap);

              print('Claves en medidaActualizadaMap: ${medidaActualizadaMap.keys}');
              print('id_medida en medidaActualizadaObj: ${medidaActualizadaObj.idMedida}');

              final success = await viewModel.actualizarMedida(medidaActualizadaObj);

              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Medición actualizada correctamente')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al actualizar: $e')),
                );
              }
            }
          },
        ),
      ),
    );
  }




}

class ChartData {
  final String fecha;
  final double valor;

  ChartData(this.fecha, this.valor);
}