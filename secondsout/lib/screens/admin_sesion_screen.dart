import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdministrarSesionesScreen extends StatefulWidget {
  final String nombreSemana;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  const AdministrarSesionesScreen({
    Key? key,
    required this.nombreSemana,
    required this.fechaInicio,
    required this.fechaFin,
  }) : super(key: key);

  @override
  _AdministrarSesionesScreenState createState() => _AdministrarSesionesScreenState();
}

class _AdministrarSesionesScreenState extends State<AdministrarSesionesScreen> {
  final List<String> _diasSeleccionados = [];
  final List<String> _diasSemana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
  int? _indiceEdicion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreSemana),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Encabezado informativo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Días de entrenamiento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue.shade100,
                  label: Text(
                    '${_diasSeleccionados.length} días',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de sesiones
          Expanded(
            child: _diasSeleccionados.isEmpty
                ? const Center(
              child: Text(
                'No hay días agregados',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _diasSeleccionados.length,
              itemBuilder: (context, index) {
                return _buildSesionItem(_diasSeleccionados[index], index);
              },
            ),
          ),

          // Botón de agregar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildAddButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Día'),
        onPressed: () => _mostrarDialogoDia(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoDia(BuildContext context, [int? index]) {
    String? diaSeleccionado;
    final esEdicion = index != null;
    final diasDisponibles = esEdicion
        ? _diasSemana
        : _diasSemana.where((dia) => !_diasSeleccionados.contains(dia)).toList();

    if (esEdicion) {
      diaSeleccionado = _diasSeleccionados[index];
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(esEdicion ? 'Editar día' : 'Agregar día'),
              content: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Día de la semana',
                  border: OutlineInputBorder(),
                ),
                value: diaSeleccionado,
                items: diasDisponibles.map((dia) {
                  return DropdownMenuItem<String>(
                    value: dia,
                    child: Text(dia),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    diaSeleccionado = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (diaSeleccionado != null) {
                      setState(() {
                        if (esEdicion) {
                          _diasSeleccionados[index] = diaSeleccionado!;
                        } else {
                          _diasSeleccionados.add(diaSeleccionado!);
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(esEdicion ? 'Guardar' : 'Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSesionItem(String dayName, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.fitness_center, color: Colors.blue),
        title: Text(dayName),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              _indiceEdicion = index;
              _mostrarDialogoDia(context, index);
            } else if (value == 'delete') {
              setState(() {
                _diasSeleccionados.removeAt(index);
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Editar'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}