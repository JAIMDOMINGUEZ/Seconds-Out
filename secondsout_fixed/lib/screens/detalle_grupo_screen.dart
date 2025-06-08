import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/grupo.dart';
import '../viewmodels/grupo_view_model.dart';
import '../data/models/atleta.dart';

class InfoGrupoScreen extends StatelessWidget {
  final Grupo grupo;

  const InfoGrupoScreen({
    super.key,
    required this.grupo,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrupoViewModel(
        atletaRepository: context.read(),
        grupoAtletaRepository: context.read(),
        idGrupo: grupo.id_grupo!,
      )..cargarAtletas(),
      child: _InfoGrupoScreenContent(grupo: grupo),
    );
  }
}

class _InfoGrupoScreenContent extends StatelessWidget {
  final Grupo grupo;

  const _InfoGrupoScreenContent({super.key, required this.grupo});

  @override
  Widget build(BuildContext context) {
    final capacidadMaxima = grupo.capacidadMaxima;

    return Scaffold(
      appBar: AppBar(
        title: Text(grupo.nombre),
      ),
      body: Consumer<GrupoViewModel>(
        builder: (context, viewModel, _) {
          final miembros = viewModel.atletasEnGrupo;
          final ocupacion = miembros.length;
          final porcentajeOcupacion = ocupacion / capacidadMaxima;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Capacidad Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ocupación: $ocupacion/$capacidadMaxima'),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: porcentajeOcupacion,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            porcentajeOcupacion >= 0.9
                                ? Colors.red
                                : porcentajeOcupacion >= 0.7
                                ? Colors.orange
                                : Colors.green,
                          ),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          porcentajeOcupacion >= 0.9
                              ? 'Capacidad casi llena'
                              : porcentajeOcupacion >= 0.7
                              ? 'Capacidad moderada'
                              : 'Capacidad disponible',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: porcentajeOcupacion >= 0.9
                                ? Colors.red
                                : porcentajeOcupacion >= 0.7
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Título + Botón
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Miembros del grupo',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: const Text('Agregar atletas'),
                      onPressed: () {
                        _mostrarDialogoSeleccionAtletas(context, capacidadMaxima);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                // Lista miembros
                Expanded(
                  child: miembros.isEmpty
                      ? const Center(child: Text('Sin miembros'))
                      : ListView.builder(
                    itemCount: miembros.length,
                    itemBuilder: (context, index) {
                      final atleta = miembros[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(atleta.usuario?.nombre ?? 'Sin nombre'),

                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            _confirmarEliminar(context, atleta);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, Atleta atleta) {
    final scaffoldContext = context; // guarda el context correcto

    showDialog(
      context: scaffoldContext, // usa ese mismo
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Eliminar a ${atleta.usuario?.nombre}?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                // usa el scaffoldContext acá, no el del dialog
                scaffoldContext.read<GrupoViewModel>().eliminarAtleta(atleta.idAtleta!);
                Navigator.pop(context);
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }


  void _mostrarDialogoSeleccionAtletas(BuildContext context, int capacidadMaxima) async {
    final viewModel = context.read<GrupoViewModel>();
    final disponibles = capacidadMaxima - viewModel.atletasEnGrupo.length;

    if (disponibles <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El grupo está lleno')),
      );
      return;
    }

    await viewModel.cargarAtletas(); // refresca disponibles

    final seleccionados = <Atleta>[];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          final disponiblesList = viewModel.atletasDisponibles;

          return AlertDialog(
            title: Text('Seleccionar atletas (máx: $disponibles)'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: disponiblesList.length,
                itemBuilder: (context, index) {
                  final atleta = disponiblesList[index];
                  final yaSeleccionado = seleccionados.contains(atleta);

                  return CheckboxListTile(
                    title: Text(atleta.usuario?.nombre ?? 'Sin nombre'),

                    value: yaSeleccionado,
                    onChanged: (value) {
                      if (value == true) {
                        if (seleccionados.length >= disponibles) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Límite alcanzado')),
                          );
                          return;
                        }
                        setStateDialog(() => seleccionados.add(atleta));
                      } else {
                        setStateDialog(() => seleccionados.remove(atleta));
                      }
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                onPressed: () async {
                  for (var atleta in seleccionados) {
                    await viewModel.agregarAtleta(atleta.idAtleta!);
                  }
                  Navigator.pop(context);
                },
                child: const Text('Agregar'),
              )
            ],
          );
        });
      },
    );
  }
}
