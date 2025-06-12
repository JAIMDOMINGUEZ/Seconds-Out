import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/ejercicio.dart';
import '../viewmodels/ejercicio_asignado_view_model.dart';
import '/data/models/ejercicio_asignado.dart';

class DetallesSesionScreen extends StatefulWidget {
  final int idSesion;
  final String nombreSesion;

  const DetallesSesionScreen({
    Key? key,
    required this.idSesion,
    required this.nombreSesion,
  }) : super(key: key);

  @override
  _DetallesSesionScreenState createState() => _DetallesSesionScreenState();
}

class _DetallesSesionScreenState extends State<DetallesSesionScreen> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreSesion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EjercicioAsignadoViewModel>().cargarEjerciciosAsignados(
          widget.idSesion);
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _mostrarDialogoEjercicio(BuildContext context, [EjercicioAsignado? ejercicioExistente]) async {
    final viewModel = Provider.of<EjercicioAsignadoViewModel>(context, listen: false);
    final ejerciciosDisponibles = viewModel.ejerciciosDisponibles;

    // Validar si hay ejercicios disponibles
    if (ejerciciosDisponibles.isEmpty) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sin ejercicios disponibles'),
          content: const Text('No hay ejercicios registrados. Por favor, añade ejercicios primero.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // Variables del estado del diálogo
    int? selectedEjercicioId = ejercicioExistente?.id_ejercicio ?? ejerciciosDisponibles.first.id_ejercicio;
    int repeticiones = ejercicioExistente?.repeticiones ?? 1;
    final tiempoTrabajoController = TextEditingController(
      text: (ejercicioExistente?.tiempoTrabajo ?? 30).toString(),
    );
    final tiempoDescansoController = TextEditingController(
      text: (ejercicioExistente?.tiempoDescanso ?? 15).toString(),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(ejercicioExistente == null ? 'Agregar Ejercicio' : 'Editar Ejercicio'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedEjercicioId,
                      items: ejerciciosDisponibles.map((ejercicio) {
                        return DropdownMenuItem<int>(
                          value: ejercicio.id_ejercicio,
                          child: Text(ejercicio.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedEjercicioId = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Ejercicio',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      isExpanded: true,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              'Repeticiones',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    setStateDialog(() {
                                      if (repeticiones > 1) repeticiones--;
                                    });
                                  },
                                ),
                                Container(
                                  width: 60,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$repeticiones',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.green,
                                  onPressed: () {
                                    setStateDialog(() {
                                      repeticiones++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: tiempoTrabajoController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo de trabajo',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: tiempoDescansoController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo de descanso ',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    tiempoTrabajoController.dispose();
                    tiempoDescansoController.dispose();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () async {
                    // Validaciones básicas
                    if (selectedEjercicioId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Selecciona un ejercicio')));
                      return;
                    }

                    // Cerrar diálogo primero
                    Navigator.of(context).pop();

                    // Mostrar indicador de carga
                    final scaffold = ScaffoldMessenger.of(context);
                    final loadingSnackBar = SnackBar(
                      content: Row(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Guardando ejercicio...'),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                    );
                    scaffold.showSnackBar(loadingSnackBar);

                    try {
                      // Crear objeto ejercicio
                      final ejercicio = EjercicioAsignado(
                        id_ejercicio_asignado: ejercicioExistente?.id_ejercicio_asignado,
                        id_sesion: widget.idSesion,
                        id_ejercicio: selectedEjercicioId!,
                        repeticiones: repeticiones,
                        tiempoTrabajo: int.tryParse(tiempoTrabajoController.text) ?? 30,
                        tiempoDescanso: int.tryParse(tiempoDescansoController.text) ?? 15,
                      );

                      // Ejecutar operación
                      final success = ejercicioExistente == null
                          ? await viewModel.agregarEjercicioAsignado(
                        idSesion: widget.idSesion,
                        idEjercicio: selectedEjercicioId!,
                        repeticiones: repeticiones,
                        tiempoTrabajo: int.tryParse(tiempoTrabajoController.text) ?? 30,
                        tiempoDescanso: int.tryParse(tiempoDescansoController.text) ?? 15,
                      ) : await viewModel.actualizarEjercicioAsignado(ejercicio);

                      // Mostrar resultado
                      if (mounted) {
                        scaffold.hideCurrentSnackBar();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? 'Ejercicio ${ejercicioExistente == null ? 'agregado' : 'actualizado'} correctamente'
                                : viewModel.errorMessage ?? 'Error desconocido'),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );

                        if (success) {
                          await viewModel.cargarEjerciciosAsignados(widget.idSesion);
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        scaffold.hideCurrentSnackBar();
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      tiempoTrabajoController.dispose();
                      tiempoDescansoController.dispose();
                    }
                  },
                  child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarConfirmacionEliminar(BuildContext context, EjercicioAsignado ejercicio) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este ejercicio?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final viewModel = context.read<EjercicioAsignadoViewModel>();
                final success = await viewModel.eliminarEjercicioAsignado(
                  ejercicio.id_ejercicio_asignado!,
                  widget.idSesion,
                );
                Navigator.of(context).pop();

                if (success) {
                  await viewModel.cargarEjerciciosAsignados(widget.idSesion);
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success ? 'Ejercicio eliminado correctamente' : 'Error al eliminar el ejercicio',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EjercicioAsignadoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Sesión: ${widget.nombreSesion}'),

      ),
      body: Column(
        children: [
          if (viewModel.isLoading) const LinearProgressIndicator(),

          if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: viewModel.ejerciciosAsignados.isEmpty
                ? const Center(
              child: Text('No hay ejercicios asignados a esta sesión'),
            )
                : ListView.builder(
              itemCount: viewModel.ejerciciosAsignados.length,
              itemBuilder: (context, index) {
                final ejercicio = viewModel.ejerciciosAsignados[index];
                final ejercicioInfo = viewModel.ejerciciosDisponibles
                    .firstWhere(
                      (e) => e.id_ejercicio == ejercicio.id_ejercicio,
                  orElse: () =>
                  viewModel.ejerciciosDisponibles.isNotEmpty
                      ? viewModel.ejerciciosDisponibles.first
                      : Ejercicio(id_ejercicio: 0,
                      nombre: 'Desconocido',
                      tipo: '',
                      descripcion: ''),
                );

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: ListTile(
                    //title: Text(ejercicioInfo.nombre),
                    title: Text('${ejercicioInfo.nombre}-${ejercicio
                        .repeticiones}(${ejercicio
                        .tiempoTrabajo}${"'"}x${ejercicio
                        .tiempoDescanso}${"'"})'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      /*children: [
                        Text('Repeticiones: ${ejercicio.repeticiones}'),
                        Text('Trabajo: ${ejercicio.tiempoTrabajo}'),
                        Text('Descanso: ${ejercicio.tiempoDescanso}'),
                      ],*/
                    ),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) =>
                      [
                        const PopupMenuItem(
                          value: 'editar',
                          child: ListTile(
                            leading: Icon(Icons.edit, size: 20),
                            title: Text('Editar'),
                          ),
                        ),

                        const PopupMenuItem(
                          value: 'eliminar',
                          child: ListTile(
                            leading: Icon(
                                Icons.delete, size: 20, color: Colors.red),
                            title: Text('Eliminar'),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'editar') {
                          _mostrarDialogoEjercicio(context, ejercicio);
                        } else if (value == 'eliminar') {
                          _mostrarConfirmacionEliminar(context, ejercicio);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () => _mostrarDialogoEjercicio(context),
          child: const Icon(Icons.add, color: Colors.white),
          elevation: 0,
        ),
      ),

    );
  }

}
