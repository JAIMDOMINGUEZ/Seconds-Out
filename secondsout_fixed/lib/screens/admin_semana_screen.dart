import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'admin_sesion_screen.dart';
import '../viewmodels/admin_semana_view_model.dart';
import '../data/models/semana.dart';

class AdminSemanaScreen extends StatefulWidget {
  final String nombreMesociclo;
  final DateTime fechaInicioMesociclo;
  final DateTime fechaFinMesociclo;
  final int idPlaneacion;

  const AdminSemanaScreen({
    super.key,
    required this.nombreMesociclo,
    required this.fechaInicioMesociclo,
    required this.fechaFinMesociclo,
    required this.idPlaneacion,
  });

  @override
  State<AdminSemanaScreen> createState() => _AdminSemanaScreenState();
}

class _AdminSemanaScreenState extends State<AdminSemanaScreen> {
  final List<Color> _coloresDisponibles = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SemanaViewModel>().cargarSemanas(widget.idPlaneacion);
    });
  }

  void _irAAdministrarSesion(Semana semana) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdministrarSesionesScreen(
          idSemana: semana.id_semana!,
          nombreSemana: semana.nombre,
          fechaInicio: semana.fechaInicio,
          fechaFin: semana.fechaFin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SemanaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Semanas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info del mesociclo
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nombreMesociclo,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

            // Loading and error states
            if (viewModel.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (viewModel.semanas.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No hay semanas registradas'),
                  ),
                )
              else
              // List of weeks
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.semanas.length,
                    itemBuilder: (context, index) {
                      final semana = viewModel.semanas[index];
                      return _buildSemanaCard(semana, index);
                    },
                  ),
                ),

            // Add week button
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Semana'),
              onPressed: () => _mostrarDialogoAgregarSemana(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemanaCard(Semana semana, int index) {
    final dateRange =
        '${DateFormat('dd/MM/yyyy').format(semana.fechaInicio)} al ${DateFormat('dd/MM/yyyy').format(semana.fechaFin)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _irAAdministrarSesion(semana),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _coloresDisponibles[index % _coloresDisponibles.length],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                semana.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(dateRange),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    _editarSemana(context, semana);
                  } else if (value == 'delete') {
                    _eliminarSemana(context, semana);
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
  }

  void _mostrarDialogoAgregarSemana(BuildContext context) {
    final viewModel = context.read<SemanaViewModel>();
    final nombreController = TextEditingController(
      text: 'Semana ${viewModel.semanas.length + 1}',
    );
    DateTime? fechaInicio;
    DateTime? fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Nueva Semana', style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la semana',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de inicio', style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        fechaInicio == null
                            ? 'Seleccionar fecha'
                            : DateFormat('dd/MM/yyyy').format(fechaInicio!),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.calendar_today, color: Colors.black),
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
                      title: const Text('Fecha de fin', style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        fechaFin == null
                            ? 'Seleccionar fecha'
                            : DateFormat('dd/MM/yyyy').format(fechaFin!),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.calendar_today, color: Colors.black),
                      onTap: () async {
                        if (fechaInicio == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Primero selecciona la fecha de inicio'),
                            ),
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
                          setStateDialog(() => fechaFin = pickedDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () async {
                    if (nombreController.text.isEmpty ||
                        fechaInicio == null ||
                        fechaFin == null ||
                        fechaFin!.isBefore(fechaInicio!) ||
                        fechaInicio!.isBefore(widget.fechaInicioMesociclo) ||
                        fechaFin!.isAfter(widget.fechaFinMesociclo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos inválidos o incompletos'),
                        ),
                      );
                      return;
                    }

                    final nuevaSemana = Semana(
                      id_planeacion: widget.idPlaneacion,
                      nombre: nombreController.text,
                      fechaInicio: fechaInicio!,
                      fechaFin: fechaFin!,
                    );

                    final success = await viewModel.registrarSemana(nuevaSemana);
                    await viewModel.cargarSemanas(widget.idPlaneacion);
                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Agregar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editarSemana(BuildContext context, Semana semana) {
    final viewModel = context.read<SemanaViewModel>();
    final nombreController = TextEditingController(text: semana.nombre);
    DateTime fechaInicio = semana.fechaInicio;
    DateTime fechaFin = semana.fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Editar Semana', style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la semana',
                        labelStyle: TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Fecha de inicio', style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(fechaInicio),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.calendar_today, color: Colors.black),
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
                      title: const Text('Fecha de fin', style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(fechaFin),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.calendar_today, color: Colors.black),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaFin,
                          firstDate: fechaInicio,
                          lastDate: widget.fechaFinMesociclo,
                        );
                        if (pickedDate != null) {
                          setStateDialog(() => fechaFin = pickedDate);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () async {
                    if (nombreController.text.isEmpty ||
                        fechaInicio.isBefore(widget.fechaInicioMesociclo) ||
                        fechaFin.isAfter(widget.fechaFinMesociclo)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fechas inválidas'),
                        ),
                      );
                      return;
                    }

                    final semanaActualizada = semana.copyWith(
                      nombre: nombreController.text,
                      fechaInicio: fechaInicio,
                      fechaFin: fechaFin,
                    );

                    final success = await viewModel.actualizarSemana(semanaActualizada);
                    await viewModel.cargarSemanas(widget.idPlaneacion);
                    if (success && mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _eliminarSemana(BuildContext context, Semana semana) {
    final viewModel = context.read<SemanaViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Semana'),
        content: const Text('¿Estás seguro de eliminar esta semana?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final success = await viewModel.eliminarSemana(semana.id_semana!);
              await viewModel.cargarSemanas(widget.idPlaneacion);
              if (success && mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}