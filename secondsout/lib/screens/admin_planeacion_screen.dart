import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'admin_semana_screen.dart';

class AdminPlaneacionScreen extends StatefulWidget {
  const AdminPlaneacionScreen({super.key});

  @override
  State<AdminPlaneacionScreen> createState() => _AdminPlaneacionScreenState();
}

class _AdminPlaneacionScreenState extends State<AdminPlaneacionScreen> {
  final List<Map<String, dynamic>> _planeaciones = [
    {
      'nombre': 'Mesociclo Acumulación',
      'fechaInicio': DateTime(2025, 1, 6),
      'fechaFin': DateTime(2025, 2, 2),
      'color': 'blue'
    },
    {
      'nombre': 'Mesociclo Transformación',
      'fechaInicio': DateTime(2025, 3, 3),
      'fechaFin': DateTime(2025, 3, 30),
      'color': 'green'
    },
  ];

  String _getRandomColor() {
    final colors = ['blue', 'green', 'orange', 'purple'];
    colors.shuffle();
    return colors.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Planeaciónes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _planeaciones.length,
                itemBuilder: (context, index) {
                  final planeacion = _planeaciones[index];
                  final fechaInicio = planeacion['fechaInicio'] as DateTime;
                  final fechaFin = planeacion['fechaFin'] as DateTime;
                  final dateRange =
                      '${DateFormat('dd/MM/yyyy').format(fechaInicio)} al ${DateFormat('dd/MM/yyyy').format(fechaFin)}';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: MesocycleCard(
                      title: planeacion['nombre'] as String,
                      dateRange: dateRange,
                      color: _getColorFromString(planeacion['color'] as String),
                      onEdit: () => _showEditDialog(context, index),
                      onDelete: () => _showDeleteDialog(context, index),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminSemanaScreen(
                              nombreMesociclo: planeacion['nombre'] as String,
                              fechaInicioMesociclo: fechaInicio,
                              fechaFinMesociclo: fechaFin,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Color _getColorFromString(String color) {
    switch (color) {
      case 'blue':
        return Colors.blue[100]!;
      case 'green':
        return Colors.green[100]!;
      case 'orange':
        return Colors.orange[100]!;
      case 'purple':
        return Colors.purple[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Widget _buildAddButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Planeación'),
        onPressed: () => _showAddDialog(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nombreController = TextEditingController();
    DateTime? fechaInicio;
    DateTime? fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nueva Planeación'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del mesociclo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(fechaInicio == null
                          ? 'Seleccionar fecha'
                          : DateFormat('dd/MM/yyyy').format(fechaInicio!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaInicio = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Fecha de fin'),
                      subtitle: Text(fechaFin == null
                          ? 'Seleccionar fecha'
                          : DateFormat('dd/MM/yyyy').format(fechaFin!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio ?? DateTime.now(),
                          firstDate: fechaInicio ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaFin = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (nombreController.text.isNotEmpty &&
                        fechaInicio != null &&
                        fechaFin != null) {
                      final nuevaPlaneacion = {
                        'nombre': nombreController.text,
                        'fechaInicio': fechaInicio!,
                        'fechaFin': fechaFin!,
                        'color': _getRandomColor(),
                      };

                      Navigator.pop(context); // Cerrar el diálogo primero
                      setState(() { // Luego actualizar el estado principal
                        _planeaciones.add(nuevaPlaneacion);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Planeación agregada')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Por favor complete todos los campos')),
                      );
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    final planeacion = _planeaciones[index];
    final nombreController = TextEditingController(text: planeacion['nombre'] as String);
    DateTime fechaInicio = planeacion['fechaInicio'] as DateTime;
    DateTime fechaFin = planeacion['fechaFin'] as DateTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Planeación'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del mesociclo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(fechaInicio)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio,
                          firstDate: DateTime(2000),
                          lastDate: fechaFin,
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaInicio = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Fecha de fin'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(fechaFin)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaFin,
                          firstDate: fechaInicio,
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaFin = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el diálogo primero
                    setState(() { // Luego actualizar el estado principal
                      _planeaciones[index] = {
                        'nombre': nombreController.text,
                        'fechaInicio': fechaInicio,
                        'fechaFin': fechaFin,
                        'color': planeacion['color'],
                      };
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Planeación actualizada')),
                    );
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Planeación'),
        content: const Text('¿Estás seguro de eliminar esta planeación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _planeaciones.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Planeación eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class MesocycleCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const MesocycleCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
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
                ],
              ),
              const SizedBox(height: 8),
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}