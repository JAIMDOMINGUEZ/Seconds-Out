import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/admin_ejercicios_view_model.dart';
import '../data/models/ejercicio.dart';
import 'agregar_ejercicio_screen.dart';
import 'editar_ejercicio_screen.dart';
import 'informacion_ejercicio_screen.dart';

class AdminEjerciciosScreen extends StatefulWidget {
  const AdminEjerciciosScreen({super.key});

  @override
  State<AdminEjerciciosScreen> createState() => _AdminEjerciciosScreenState();
}

class _AdminEjerciciosScreenState extends State<AdminEjerciciosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EjercicioViewModel>().cargarEjercicios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EjercicioViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Ejercicios'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        foregroundColor: Colors.black, // texto y iconos blancos
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: viewModel.ejercicios.isEmpty
                  ? const Center(child: Text('No hay ejercicios registrados.'))
                  : ListView.builder(
                itemCount: viewModel.ejercicios.length,
                itemBuilder: (context, index) {
                  final ejercicio = viewModel.ejercicios[index];
                  return _EjercicioItem(
                    ejercicio: ejercicio,
                      onEdit: () async {
                        await _editarEjercicio(ejercicio);
                      },

                    onDelete: () async {
                      final confirmado = await _mostrarDialogoConfirmacion(context, ejercicio.nombre);
                      if (confirmado == true && context.mounted) {
                        try {
                          await context.read<EjercicioViewModel>()
                              .eliminarEjercicio(ejercicio.id_ejercicio!);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ejercicio eliminado')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al eliminar: ${e.toString()}')),
                            );
                          }
                        }
                      }
                    },
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
  Future<bool?> _mostrarDialogoConfirmacion(BuildContext context, String nombre) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de eliminar el ejercicio $nombre?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
  Future<void> _editarEjercicio(Ejercicio ejercicio) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarEjercicioScreen(ejercicio: ejercicio.toJson()),
      ),
    );

    if (resultado != null && resultado is Map<String, dynamic>) {
      // Verifica que el ID se mantenga
      if (resultado['id_ejercicio'] == null) {
        resultado['id_ejercicio'] = ejercicio.id_ejercicio;
      }

      final ejercicioActualizado = Ejercicio.fromJson(resultado);

      await context.read<EjercicioViewModel>().actualizarEjercicio(ejercicioActualizado);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ejercicio actualizado correctamente')),
        );
      }
    }
  }
  }


  Widget _buildAddButton(BuildContext context) {
    final viewModel = context.read<EjercicioViewModel>();
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Ejercicio'),
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrarEjercicioScreen(),
            ),
          );
          if (resultado != null) {
            await viewModel.agregarEjercicio(resultado);
          }
        },
      ),
    );
  }


class _EjercicioItem extends StatelessWidget {
  final Ejercicio ejercicio;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EjercicioItem({
    required this.ejercicio,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InformacionEjercicioScreen(ejercicio: ejercicio.toJson()),
            ),
          );
        },
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForExerciseType(ejercicio.tipo),
              color: Colors.black,
            ),
          ),
          title: Text(
            ejercicio.nombre,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(ejercicio.tipo),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForExerciseType(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'boxeo':
        return Icons.sports_mma;
      case 'acondicionamiento':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }
}
