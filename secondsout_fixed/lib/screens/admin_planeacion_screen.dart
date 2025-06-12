import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodels/admin_pleaneaciones_view_model.dart';
import '../viewmodels/admin_semana_view_model.dart' show SemanaViewModel;
import '/data/models/planeacion.dart';
import 'admin_semana_screen.dart';

class AdminPlaneacionScreen extends StatefulWidget {
  const AdminPlaneacionScreen({super.key});

  @override
  State<AdminPlaneacionScreen> createState() => _AdminPlaneacionScreenState();
}

class _AdminPlaneacionScreenState extends State<AdminPlaneacionScreen> {
  bool _initialLoadDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<AdminPlaneacionesViewModel>(context, listen: false);

    if (!_initialLoadDone && viewModel.planeaciones.isEmpty && !viewModel.isLoading) {
      _initialLoadDone = true;
      viewModel.cargarPlaneaciones();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminPlaneacionesViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Planeaciones'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        foregroundColor: Colors.black, // texto y iconos blancos
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (viewModel.isLoading)
              const CircularProgressIndicator()
            else if (viewModel.errorMessage != null)
              Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.planeaciones.length,
                itemBuilder: (context, index) {
                  final planeacion = viewModel.planeaciones[index];
                  final dateRange =
                      '${DateFormat('dd/MM/yyyy').format(planeacion.fechaInicio)} al ${DateFormat('dd/MM/yyyy').format(planeacion.fechaFin)}';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: MesocycleCard(
                      title: planeacion.nombre,
                      dateRange: dateRange,
                      color: _getRandomColor(),
                      onEdit: () => _showEditDialog(context, viewModel, planeacion),
                      onDelete: () => _showDeleteDialog(context, viewModel, planeacion.id_planeacion!),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider.value(
                              value: Provider.of<SemanaViewModel>(context, listen: false),
                              child: AdminSemanaScreen(
                                nombreMesociclo: planeacion.nombre,
                                fechaInicioMesociclo: planeacion.fechaInicio,
                                fechaFinMesociclo: planeacion.fechaFin,
                                idPlaneacion: planeacion.id_planeacion!,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            _buildAddButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  // Método que devuelve un color aleatorio para las cards
  Color _getRandomColor() {
    final colors = [
      Colors.blue[100]!,
      Colors.green[100]!,
      Colors.orange[100]!,
      Colors.purple[100]!,
      Colors.teal[100]!,
      Colors.red[100]!,
    ];
    colors.shuffle();
    return colors.first;
  }

  Widget _buildAddButton(BuildContext context, AdminPlaneacionesViewModel viewModel) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Planeación'),
        onPressed: () => _showAddDialog(context, viewModel),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, AdminPlaneacionesViewModel viewModel) {
    final nombreController = TextEditingController();
    DateTime? fechaInicio;
    DateTime? fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Nueva Planeación', style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Nombre del mesociclo',
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
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setStateDialog(() => fechaInicio = picked);
                      },
                    ),
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
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio ?? DateTime.now(),
                          firstDate: fechaInicio ?? DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setStateDialog(() => fechaFin = picked);
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
                    if (nombreController.text.isNotEmpty && fechaInicio != null && fechaFin != null) {
                      final success = await viewModel.registrarPlaneacion(
                        nombre: nombreController.text,
                        fechaInicio: fechaInicio!,
                        fechaFin: fechaFin!,
                      );
                      if (success) Navigator.pop(context);
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


  void _showEditDialog(BuildContext context, AdminPlaneacionesViewModel viewModel, Planeacion planeacion) {
    final nombreController = TextEditingController(text: planeacion.nombre);
    DateTime fechaInicio = planeacion.fechaInicio;
    DateTime fechaFin = planeacion.fechaFin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Editar Planeación', style: TextStyle(color: Colors.black)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nombreController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: 'Nombre del mesociclo',
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
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fechaInicio,
                          firstDate: DateTime(2000),
                          lastDate: fechaFin,
                        );
                        if (picked != null) setStateDialog(() => fechaInicio = picked);
                      },
                    ),
                    ListTile(
                      title: const Text('Fecha de fin', style: TextStyle(color: Colors.black)),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(fechaFin),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.calendar_today, color: Colors.black),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: fechaFin,
                          firstDate: fechaInicio,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setStateDialog(() => fechaFin = picked);
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
                    final updated = planeacion.copyWith(
                      nombre: nombreController.text,
                      fechaInicio: fechaInicio,
                      fechaFin: fechaFin,
                    );
                    final success = await viewModel.actualizarPlaneacion(updated);
                    if (success) Navigator.pop(context);
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



  void _showDeleteDialog(BuildContext context, AdminPlaneacionesViewModel viewModel, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Planeación'),
        content: const Text('¿Estás seguro de eliminar esta planeación?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await viewModel.eliminarPlaneacion(id);
              Navigator.pop(context);
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
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MesocycleCard({
    super.key,
    required this.title,
    required this.dateRange,
    required this.color,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateRange),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
