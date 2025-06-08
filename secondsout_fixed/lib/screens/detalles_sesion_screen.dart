import 'package:flutter/material.dart';

class DetallesSesionScreen extends StatefulWidget {
  final String nombreSesion;

  const DetallesSesionScreen({
    Key? key,
    required this.nombreSesion,
  }) : super(key: key);

  @override
  _DetallesSesionScreenState createState() => _DetallesSesionScreenState();
}

class _DetallesSesionScreenState extends State<DetallesSesionScreen> {
  final List<String> _ejercicios = [];
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.nombreSesion;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _mostrarDialogoEjercicio(BuildContext context, [int? index]) async {
    String tipoEjercicio = 'Sombra';
    int repeticiones = 1;
    double tiempoTrabajo = 4.0;
    double tiempoDescanso = 1.0;

    final trabajoController = TextEditingController(text: tiempoTrabajo.toString());
    final descansoController = TextEditingController(text: tiempoDescanso.toString());

    if (index != null) {
      try {
        final parts = _ejercicios[index].split(' ');
        tipoEjercicio = parts[0];
        repeticiones = int.parse(parts[1].split('(')[0]);
        final tiempos = parts[1].split('(')[1].replaceAll(")", "").split('x');
        tiempoTrabajo = double.parse(tiempos[0].replaceAll("'", ""));
        tiempoDescanso = double.parse(tiempos[1]);

        trabajoController.text = tiempoTrabajo.toString();
        descansoController.text = tiempoDescanso.toString();
      } catch (e) {
        debugPrint('Error al parsear ejercicio: $e');
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(index == null ? 'Agregar Ejercicio' : 'Editar Ejercicio'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: tipoEjercicio,
                      items: ['Sombra', 'Costal', 'Salto', 'Otro']
                          .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          tipoEjercicio = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de ejercicio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Repeticiones'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setStateDialog(() {
                              if (repeticiones > 1) repeticiones--;
                            });
                          },
                        ),
                        Text('$repeticiones'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setStateDialog(() {
                              repeticiones++;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: trabajoController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo de trabajo (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        final val = double.tryParse(value) ?? tiempoTrabajo;
                        setStateDialog(() {
                          tiempoTrabajo = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descansoController,
                      decoration: const InputDecoration(
                        labelText: 'Tiempo de descanso (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        final val = double.tryParse(value) ?? tiempoDescanso;
                        setStateDialog(() {
                          tiempoDescanso = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () {
                    final ejercicio =
                        "$tipoEjercicio $repeticiones(${tiempoTrabajo.toStringAsFixed(1)}'x${tiempoDescanso.toStringAsFixed(1)})";

                    setState(() {
                      if (index == null) {
                        _ejercicios.add(ejercicio);
                      } else {
                        _ejercicios[index] = ejercicio;
                      }
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarConfirmacionEliminar(BuildContext context, int index) async {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _ejercicios.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcionesEjercicio(BuildContext context, int index) async {
    final seleccion = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 1000, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'eliminar',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Eliminar'),
          ),
        ),
      ],
    );

    if (seleccion == 'editar') {
      _mostrarDialogoEjercicio(context, index);
    } else if (seleccion == 'eliminar') {
      await _mostrarConfirmacionEliminar(context, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Sesión: ${widget.nombreSesion}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _ejercicios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_ejercicios[index]),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'editar') {
                        _mostrarDialogoEjercicio(context, index);
                      } else if (value == 'eliminar') {
                        _mostrarConfirmacionEliminar(context, index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('Eliminar'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _mostrarDialogoEjercicio(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}