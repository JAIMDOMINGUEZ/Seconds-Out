import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'agregar_medida_screen.dart';
import 'editar_medida_screen.dart';

class AdminMedidasScreen extends StatefulWidget {
  final List<Map<String, dynamic>> medidas;

  const AdminMedidasScreen({super.key, required this.medidas});

  @override
  State<AdminMedidasScreen> createState() => _AdminMedidasScreenState();
}

class _AdminMedidasScreenState extends State<AdminMedidasScreen> {
  late List<Map<String, dynamic>> _medidas;
  List<Map<String, dynamic>> _filteredMedidas = [];
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
  void initState() {
    super.initState();
    _medidas = widget.medidas;
    _filteredMedidas = List.from(_medidas);
    // Ordenar medidas por fecha (más reciente primero)
    _medidas.sort((a, b) => DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])));
    _filteredMedidas.sort((a, b) => DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])));

    _searchController.addListener(_filterMedidas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMedidas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedidas = _medidas.where((medida) {
        final fecha = DateFormat('dd/MM/yyyy').format(DateTime.parse(medida['fecha'])).toLowerCase();
        final peso = medida['peso']?.toString().toLowerCase() ?? '';
        final talla = medida['talla']?.toString().toLowerCase() ?? '';

        return fecha.contains(query) ||
            peso.contains(query) ||
            talla.contains(query);
      }).toList();
    });
  }

  void _eliminarMedida(int index) {
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
              setState(() {
                final medidaToRemove = _filteredMedidas[index];
                _medidas.remove(medidaToRemove);
                _filteredMedidas.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medición eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editarMedida(int index) {
    final medidaAEditar = _filteredMedidas[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarMedidaAntropometricaScreen(
          medidaExistente: medidaAEditar,
          onGuardar: (medidaActualizada) {
            setState(() {
              // Actualizar la medida en ambas listas
              final indiceOriginal = _medidas.indexWhere(
                      (m) => m['fecha'] == medidaAEditar['fecha']
              );

              if (indiceOriginal != -1) {
                _medidas[indiceOriginal] = medidaActualizada;
              }

              _filteredMedidas[index] = medidaActualizada;

              // Reordenar por fecha
              _medidas.sort((a, b) => DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])));
              _filteredMedidas.sort((a, b) => DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])));
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medición actualizada correctamente')),
            );
          },
        ),
      ),
    );
  }

  void _agregarNuevaMedida() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedidaAntropometricaScreen(
          onGuardar: (nuevaMedida) {
            setState(() {
              _medidas.insert(0, nuevaMedida);
              _filterMedidas();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medición agregada correctamente')),
            );
          },
        ),
      ),
    );
  }

  List<ChartData> _getChartData() {
    return _filteredMedidas.map((medida) {
      double value;
      switch (_selectedChart) {
        case 'IMC':
          value = medida['imc']?.toDouble() ?? 0.0;
          break;
        case '% Graso':
          value = medida['p_graso']?.toDouble() ?? 0.0;
          break;
        case '% Muscular':
          value = medida['p_muscular']?.toDouble() ?? 0.0;
          break;
        case '% Óseo':
          value = medida['p_oseo']?.toDouble() ?? 0.0;
          break;
        case 'Peso':
          value = medida['peso']?.toDouble() ?? 0.0;
          break;
        case 'Talla':
          value = medida['talla']?.toDouble() ?? 0.0;
          break;
        default:
          value = 0.0;
      }

      return ChartData(
        DateFormat('dd/MM/yy').format(DateTime.parse(medida['fecha'])),
        value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Medidas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por fecha, peso o talla...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Gráfico de seguimiento
          Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Evolución de $_selectedChart'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: _getChartData(),
                  xValueMapper: (ChartData data, _) => data.fecha,
                  yValueMapper: (ChartData data, _) => data.valor,
                  name: _selectedChart,
                  markerSettings: const MarkerSettings(isVisible: true),
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                )
              ],
            ),
          ),

          // Selector de gráfico
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

          // Listado de medidas
          Expanded(
            child: _filteredMedidas.isEmpty
                ? const Center(
              child: Text(
                'No hay medidas registradas',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _filteredMedidas.length,
              itemBuilder: (context, index) {
                final medida = _filteredMedidas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.assessment, color: Colors.blue),
                    title: Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(medida['fecha'])),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peso: ${medida['peso']?.toStringAsFixed(2) ?? 'N/A'} kg'),
                        Text('Talla: ${medida['talla']?.toStringAsFixed(2) ?? 'N/A'} cm'),
                        Text('IMC: ${medida['imc']?.toStringAsFixed(2) ?? 'N/A'}'),
                        Text('% Graso: ${medida['p_graso']?.toStringAsFixed(2) ?? 'N/A'}'),
                        Text('% Muscular: ${medida['p_muscular']?.toStringAsFixed(2) ?? 'N/A'}'),
                        Text('% Óseo: ${medida['p_oseo']?.toStringAsFixed(2) ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarMedida(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarMedida(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _agregarNuevaMedida,
      ),
    );
  }
}

class ChartData {
  final String fecha;
  final double valor;

  ChartData(this.fecha, this.valor);
}