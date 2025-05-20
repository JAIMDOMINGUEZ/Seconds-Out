import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'admin_sesion_screen.dart'; // Asegúrate de tener esta pantalla creada

class AdminSemanaScreen extends StatefulWidget {
  final String nombreMesociclo;
  final DateTime fechaInicioMesociclo;
  final DateTime fechaFinMesociclo;

  const AdminSemanaScreen({
    super.key,
    required this.nombreMesociclo,
    required this.fechaInicioMesociclo,
    required this.fechaFinMesociclo,
  });

  @override
  State<AdminSemanaScreen> createState() => _AdminSemanaScreenState();
}

class _AdminSemanaScreenState extends State<AdminSemanaScreen> {
  final List<Map<String, dynamic>> _semanas = [];
  final List<Color> _coloresDisponibles = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
  ];

  Color _getRandomColor() {
    _coloresDisponibles.shuffle();
    return _coloresDisponibles.first;
  }

  void _irAAdministrarSesion(Map<String, dynamic> semana) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdministrarSesionesScreen(
          nombreSemana: semana['nombre'],
          fechaInicio: semana['fechaInicio'], // Esto es DateTime pero se espera String
          fechaFin: semana['fechaFin'], // Esto es DateTime pero se espera String
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semanas - ${widget.nombreMesociclo}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info del mesociclo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.nombreMesociclo,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(widget.fechaInicioMesociclo)} al ${DateFormat('dd/MM/yyyy').format(widget.fechaFinMesociclo)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Lista de semanas
            Expanded(
              child: ListView.builder(
                itemCount: _semanas.length,
                itemBuilder: (context, index) {
                  final semana = _semanas[index];
                  final fechaInicio = semana['fechaInicio'] as DateTime;
                  final fechaFin = semana['fechaFin'] as DateTime;
                  final dateRange =
                      '${DateFormat('dd/MM/yyyy').format(fechaInicio)} al ${DateFormat('dd/MM/yyyy').format(fechaFin)}';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => _irAAdministrarSesion(semana),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: semana['color'] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(semana['nombre'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(dateRange),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editarSemana(context, index);
                                } else if (value == 'delete') {
                                  _eliminarSemana(context, index);
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botón agregar semana
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Semana'),
              onPressed: () => _mostrarDialogoAgregarSemana(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoAgregarSemana(BuildContext context) {
    final nombreController = TextEditingController(text: 'Semana ${_semanas.length + 1}');
    DateTime? fechaInicio;
    DateTime? fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Nueva Semana'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la semana',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de inicio'),
                      subtitle: Text(
                        fechaInicio == null
                            ? 'Seleccionar fecha'
                            : DateFormat('dd/MM/yyyy').format(fechaInicio!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.fechaInicioMesociclo,
                          firstDate: widget.fechaInicioMesociclo,
                          lastDate: widget.fechaFinMesociclo,
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaInicio = pickedDate;
                            if (fechaFin != null && fechaFin!.isBefore(pickedDate)) {
                              fechaFin = null;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Fecha de fin'),
                      subtitle: Text(
                        fechaFin == null
                            ? 'Seleccionar fecha'
                            : DateFormat('dd/MM/yyyy').format(fechaFin!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        if (fechaInicio == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Primero selecciona la fecha de inicio')),
                          );
                          return;
                        }
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio!,
                          firstDate: fechaInicio!,
                          lastDate: widget.fechaFinMesociclo,
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
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    if (nombreController.text.isEmpty ||
                        fechaInicio == null ||
                        fechaFin == null ||
                        fechaFin!.isBefore(fechaInicio!) ||
                        fechaInicio!.isBefore(widget.fechaInicioMesociclo) ||
                        fechaFin!.isAfter(widget.fechaFinMesociclo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos inválidos o incompletos')),
                      );
                      return;
                    }

                    final nuevaSemana = {
                      'nombre': nombreController.text,
                      'fechaInicio': fechaInicio!,
                      'fechaFin': fechaFin!,
                      'color': _getRandomColor(),
                    };

                    setState(() {
                      _semanas.add(nuevaSemana);
                    });

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semana agregada')),
                    );

                    _irAAdministrarSesion(nuevaSemana);
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

  void _editarSemana(BuildContext context, int index) {
    final semana = _semanas[index];
    final nombreController = TextEditingController(text: semana['nombre'] as String);
    DateTime fechaInicio = semana['fechaInicio'] as DateTime;
    DateTime fechaFin = semana['fechaFin'] as DateTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Editar Semana'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la semana',
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
                          firstDate: widget.fechaInicioMesociclo,
                          lastDate: widget.fechaFinMesociclo,
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            fechaInicio = pickedDate;
                            if (fechaFin.isBefore(fechaInicio)) {
                              fechaFin = fechaInicio;
                            }
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
                          lastDate: widget.fechaFinMesociclo,
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
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    if (nombreController.text.isEmpty ||
                        fechaInicio.isBefore(widget.fechaInicioMesociclo) ||
                        fechaFin.isAfter(widget.fechaFinMesociclo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fechas inválidas')),
                      );
                      return;
                    }

                    setState(() {
                      _semanas[index] = {
                        'nombre': nombreController.text,
                        'fechaInicio': fechaInicio,
                        'fechaFin': fechaFin,
                        'color': semana['color'],
                      };
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Semana actualizada')),
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

  void _eliminarSemana(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Semana'),
        content: const Text('¿Estás seguro de eliminar esta semana?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              setState(() {
                _semanas.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semana eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
