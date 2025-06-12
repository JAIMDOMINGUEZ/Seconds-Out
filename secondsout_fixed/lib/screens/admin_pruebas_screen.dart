import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models/prueba_tecnica.dart';
import '/viewmodels/prueba_tecnica_view_model.dart';
import 'agregar_pruebas_screen.dart';

class AdminPruebasScreen extends StatefulWidget {
  final int atletaId;

  const AdminPruebasScreen({
    super.key,
    required this.atletaId,
  });

  @override
  State<AdminPruebasScreen> createState() => _AdminPruebasScreenState();
}

class _AdminPruebasScreenState extends State<AdminPruebasScreen> {
  final DateFormat _formatoFecha = DateFormat('dd/MM/yy');

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<PruebasTecnicasViewModel>(context, listen: false);
    viewModel.cargarPruebas(widget.atletaId);
  }

  Future<void> _seleccionarFecha(
      BuildContext context,
      DateTime? fechaInicial,
      ValueChanged<DateTime> onFechaSeleccionada,
      ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onFechaSeleccionada(picked);
    }
  }

  void _mostrarAgregarDialog(BuildContext context, PruebasTecnicasViewModel viewModel) {
    DateTime? fechaSeleccionada;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Agregar Prueba'),
            content: TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(fechaSeleccionada == null
                  ? 'Selecciona fecha'
                  : _formatoFecha.format(fechaSeleccionada!)),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setStateDialog(() {
                    fechaSeleccionada = picked;
                  });
                }
              },
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Agregar'),
                onPressed: fechaSeleccionada == null
                    ? null
                    : () async {
                        final nuevoId = await viewModel.agregarPrueba(fechaSeleccionada!, widget.atletaId);
                        Navigator.pop(context);
                        if (nuevoId != null) {
                        _irAPantallaResumen(nuevoId);
                         } else {
                               print('no se pudo agregar');
                          }
                    },

              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _mostrarDialogoConfirmacion(
      BuildContext context, PruebasTecnicasViewModel viewModel, int id) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta prueba?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await viewModel.eliminarPrueba(id, widget.atletaId);
              Navigator.of(context).pop();
            },

          ),
        ],
      ),
    );

  }
  void _mostrarEditarFechaDialog(BuildContext context, PruebasTecnicasViewModel viewModel, PruebaTecnica prueba) {
    DateTime? fechaSeleccionada = prueba.fecha;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Editar Fecha de Prueba'),
            content: TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(fechaSeleccionada == null
                  ? 'Selecciona fecha'
                  : _formatoFecha.format(fechaSeleccionada!)),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: prueba.fecha,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setStateDialog(() {
                    fechaSeleccionada = picked;
                  });
                }
              },
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (fechaSeleccionada != null) {
                    final pruebaActualizada = PruebaTecnica(
                      id_prueba: prueba.id_prueba,
                      idAtleta: prueba.idAtleta,
                      fecha: fechaSeleccionada!,
                      puntajeTotal: prueba.puntajeTotal,
                    );

                    await viewModel.actualizarPrueba(pruebaActualizada);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }
  void _irAPantallaResumen(int idPrueba) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgregarPruebasScreen(idPrueba: idPrueba),
      ),
    );
  }






  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PruebasTecnicasViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Pruebas'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Historial de Pruebas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.pruebas.length,
                itemBuilder: (context, index) {
                  final prueba = viewModel.pruebas[index];
                  final estaCompleta = viewModel.esPruebaCompleta(prueba);
                  final puntaje = prueba.puntajeTotal;
                  final estado = estaCompleta
                      ? (puntaje >= 80
                      ? 'BIEN'
                      : puntaje >= 60
                      ? 'REGULAR'
                      : 'MAL')
                      : 'PENDIENTE';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _irAPantallaResumen(prueba.id_prueba!),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: estaCompleta
                              ? (estado == 'BIEN'
                              ? Colors.green
                              : estado == 'REGULAR'
                              ? Colors.orange
                              : Colors.red)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                        const Icon(Icons.assignment, color: Colors.white),
                      ),
                      title: Text(
                        _formatoFecha.format(prueba.fecha),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estado: $estado'),
                          if (!estaCompleta)
                            const Text(
                              'Faltan pruebas por completar',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _mostrarEditarFechaDialog(context, viewModel, prueba),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _mostrarDialogoConfirmacion(context, viewModel, prueba.id_prueba!),
                          ),
                        ],
                      ),



                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar Prueba'),
              onPressed: () => _mostrarAgregarDialog(context, viewModel),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
