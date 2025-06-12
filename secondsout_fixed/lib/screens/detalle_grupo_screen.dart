import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/grupo.dart';
import '../data/models/planeacion.dart' show Planeacion;
import '../data/models/planeacion_grupo.dart';
import '../viewmodels/admin_pleaneaciones_view_model.dart' show AdminPlaneacionesViewModel;
import '../viewmodels/admin_semana_view_model.dart';
import '../viewmodels/grupo_view_model.dart';
import '../data/models/atleta.dart';
import 'admin_semana_screen.dart';
import '../viewmodels/planeacion_grupo_view_model.dart'; // importa tu ViewModel

class InfoGrupoScreen extends StatelessWidget {
  final Grupo grupo;

  const InfoGrupoScreen({
    super.key,
    required this.grupo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GrupoViewModel(
            atletaRepository: context.read(),
            grupoAtletaRepository: context.read(),
            idGrupo: grupo.id_grupo!,
          )..cargarAtletas(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaneacionGrupoViewModel(
            database: context.read(), // Asegúrate de pasar tu instancia de DB aquí
          )..cargarPlaneacionGrupos(),
        ),
      ],
      child: _InfoGrupoScreenContent(grupo: grupo),
    );
  }
}

class _InfoGrupoScreenContent extends StatefulWidget {
  final Grupo grupo;

  const _InfoGrupoScreenContent({super.key, required this.grupo});

  @override
  State<_InfoGrupoScreenContent> createState() => _InfoGrupoScreenContentState();
}

class _InfoGrupoScreenContentState extends State<_InfoGrupoScreenContent> {
  String? _selectedPlaneacion;
  Planeacion? _contenidoPlaneacionSeleccionada; // guardamos el objeto completo

  @override
  void initState() {
    super.initState();
    _cargarPlaneacionAsignada();
  }

  Future<void> _cargarPlaneacionAsignada() async {
    final vm = context.read<PlaneacionGrupoViewModel>();
    await vm.cargarPlaneacionGrupos();

    PlaneacionGrupo? pg;
    try {
      pg = vm.planeacionGrupos.firstWhere(
            (pg) => pg.id_grupo == widget.grupo.id_grupo,
      );
    } catch (e) {
      pg = null;
    }

    if (pg != null) {
      final adminVM = context.read<AdminPlaneacionesViewModel>();
      await adminVM.cargarPlaneaciones();

      Planeacion? planeacion;
      try {
        planeacion = adminVM.planeaciones.firstWhere(
              (p) => p.id_planeacion == pg!.id_planeacion,
        );
      } catch (e) {
        planeacion = null;
      }

      if (planeacion != null) {
        setState(() {
          _selectedPlaneacion = planeacion!.nombre;
          _contenidoPlaneacionSeleccionada = planeacion;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final capacidadMaxima = widget.grupo.capacidadMaxima;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grupo.nombre),
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
                // Planeación seleccionada
                Card(
                  color: Colors.blue.shade50,
                  child: ListTile(
                    onTap: _contenidoPlaneacionSeleccionada != null
                        ? () => _irAAdministrarSemana(_contenidoPlaneacionSeleccionada!)
                        : null,
                    leading: const Icon(Icons.event_note),
                    title: Text(_selectedPlaneacion ?? 'Ninguna'),
                    subtitle: _contenidoPlaneacionSeleccionada != null
                        ? Text(
                      'Inicio: ${_contenidoPlaneacionSeleccionada!.fechaInicio.toLocal().toString().split(' ')[0]} - Fin: ${_contenidoPlaneacionSeleccionada!.fechaFin.toLocal().toString().split(' ')[0]}',
                    )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: _mostrarDialogoSeleccionPlaneacion,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Resto del contenido del screen (ocupación, miembros, etc)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Miembros del grupo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                Expanded(
                  child: miembros.isEmpty
                      ? const Center(child: Text('Sin miembros'))
                      : ListView.builder(
                    itemCount: miembros.length,
                    itemBuilder: (context, index) {
                      final atleta = miembros[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
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

  void _mostrarDialogoSeleccionPlaneacion() async {
    final planeacionesViewModel = context.read<AdminPlaneacionesViewModel>();

    if (planeacionesViewModel.planeaciones.isEmpty) {
      await planeacionesViewModel.cargarPlaneaciones();
    }

    final planeaciones = planeacionesViewModel.planeaciones;

    if (planeaciones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay planeaciones registradas')),
      );
      return;
    }

    String? seleccionTemporal = _selectedPlaneacion ?? planeaciones.first.nombre;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar planeación'),
          content: DropdownButtonFormField<String>(
            items: planeaciones.map((planeacion) {
              return DropdownMenuItem(
                value: planeacion.nombre,
                child: Text(planeacion.nombre),
              );
            }).toList(),
            value: seleccionTemporal,
            onChanged: (valor) {
              seleccionTemporal = valor;
            },
            decoration: const InputDecoration(labelText: 'Planeación'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final planeacionSeleccionada = planeaciones.firstWhere(
                      (p) => p.nombre == seleccionTemporal,
                );

                final vm = context.read<PlaneacionGrupoViewModel>();

                final pgExistente = () {
                  try {
                    return vm.planeacionGrupos.firstWhere(
                          (pg) => pg.id_grupo == widget.grupo.id_grupo,
                    );
                  } catch (_) {
                    return null;
                  }
                }();

                final nuevaPlaneacionGrupo = PlaneacionGrupo(
                  id_planeacion_grupo: pgExistente?.id_planeacion_grupo, // Aquí se pone el ID existente o null
                  id_grupo: widget.grupo.id_grupo!,
                  id_planeacion: planeacionSeleccionada.id_planeacion!,
                );

                if (pgExistente == null) {
                  await vm.agregarPlaneacionGrupo(nuevaPlaneacionGrupo);
                } else {
                  await vm.actualizarPlaneacionGrupo(nuevaPlaneacionGrupo);
                }

                setState(() {
                  _selectedPlaneacion = seleccionTemporal;
                  _contenidoPlaneacionSeleccionada = planeacionSeleccionada;
                });

                Navigator.pop(context);
              },
              child: const Text('Seleccionar'),
            ),
          ],
        );
      },
    );
  }


  void _irAAdministrarSemana(Planeacion planeacion) {
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
  }

  void _confirmarEliminar(BuildContext context, Atleta atleta) {
    final scaffoldContext = context;

    showDialog(
      context: scaffoldContext,
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

    await viewModel.cargarAtletas();

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
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
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
