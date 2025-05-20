import 'package:flutter/material.dart';
import 'package:secondsout/data/models/prueba_fisica.dart';
import 'package:secondsout/screens/prueba_psicologica_screen.dart';
import 'package:secondsout/screens/prueba_reglas_screen.dart';
import 'prueba_fisica_screen.dart';
import 'prueba_tactica_screen.dart';
import 'prueba_tecnica_detallada_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Pruebas Deportivas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EditarPruebasScreen(
        prueba: {
          'tipo': 'Nueva Prueba',
          'puntaje': 0,
          'id': '0',
          'fecha': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
        },
        onGuardar: (pruebaActualizada) {
          // Lógica para guardar la prueba
        },
      ),
    );
  }
}

class EditarPruebasScreen extends StatefulWidget {
  final Map<String, dynamic> prueba;
  final Function(Map<String, dynamic>) onGuardar;

  const EditarPruebasScreen({
    super.key,
    required this.prueba,
    required this.onGuardar,
  });

  @override
  State<EditarPruebasScreen> createState() => _EditarPruebasScreenState();
}

class _EditarPruebasScreenState extends State<EditarPruebasScreen> {
  late DateTime _fechaSeleccionada;
  late TextEditingController _fechaController;
  final List<Map<String, dynamic>> _pruebas = [];

  @override
  void initState() {
    super.initState();
    // Parsear la fecha recibida o usar la actual si no existe
    if (widget.prueba['fecha'] != null) {
      final parts = widget.prueba['fecha'].split('/');
      _fechaSeleccionada = DateTime(
        int.parse(parts[2]), // año
        int.parse(parts[1]), // mes
        int.parse(parts[0]), // día
      );
    } else {
      _fechaSeleccionada = DateTime.now();
    }
    _fechaController = TextEditingController(
      text: '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
    );

    // Inicializar con datos de prueba si es necesario
    _pruebas.addAll([
      {'tipo': 'Fisica', 'puntaje': 10, 'id': '1', 'fecha': _fechaController.text},
      {
        'tipo': 'Tecnica Detallada',
        'puntaje': 8,
        'id': '2',
        'fecha': _fechaController.text,
        'detalles': ['Distancia de Golpeo', 'Movilidad']
      },
      {'tipo': 'Tactica', 'puntaje': 10, 'id': '3', 'fecha': _fechaController.text},
      {'tipo': 'Psicologica', 'puntaje': 5, 'id': '4', 'fecha': _fechaController.text},
      {'tipo': 'Reglas', 'puntaje': 2, 'id': '5', 'fecha': _fechaController.text},
    ]);
  }

  @override
  void dispose() {
    _fechaController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (fecha != null && fecha != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = fecha;
        _fechaController.text = '${fecha.day}/${fecha.month}/${fecha.year}';
      });
    }
  }

  void _guardarPruebas() {
    final pruebaActualizada = {
      ...widget.prueba,
      'fecha': _fechaController.text,
    };
    widget.onGuardar(pruebaActualizada);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pruebas guardadas correctamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddTestDialog(BuildContext context) {
    final List<String> testTypes = [
      'Fisica',
      'Tecnica Detallada',
      'Tactica',
      'Psicologica',
      'Reglas'
    ];

    // Filtrar solo los tipos que no están ya en las pruebas
    final availableTestTypes = testTypes.where((type) {
      return !_pruebas.any((prueba) => prueba['tipo'] == type);
    }).toList();

    if (availableTestTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya existen pruebas de todos los tipos disponibles'),
          duration: Duration(seconds: 2),
        ));
        return;
      }

        showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Seleccionar tipo de prueba'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableTestTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availableTestTypes[index]),
                    onTap: () {
                      Navigator.pop(context);
                      _addNewTest(availableTestTypes[index]);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }

  void _addNewTest(String testType) {
    // Verificar si ya existe una prueba de este tipo
    if (_pruebas.any((prueba) => prueba['tipo'] == testType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ya existe una prueba de tipo $testType'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final nuevaPruebaBase = {
      'tipo': testType,
      'puntaje': 0,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'fecha': _fechaController.text,
    };

    if (testType == 'Tecnica Detallada') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AgregarPruebaTecnicaScreen(),
        ),
      );
    } else if (testType == 'Fisica') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaFisicaScreen(
            onGuardar: (nuevaPrueba) {
              setState(() {
                _pruebas.add({
                  ...nuevaPruebaBase,
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'detalles': {
                    'rapidez': nuevaPrueba.rapidez,
                    'fuerza': nuevaPrueba.fuerza,
                    'reaccion': nuevaPrueba.reaccion,
                    'explosividad': nuevaPrueba.explosividad,
                    'coordinacion': nuevaPrueba.coordinacion,
                  },
                });
              });
            },
          ),
        ),
      );
    } else if (testType == 'Tactica') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaTacticaScreen(
            onGuardar: (nuevaPrueba) {
              setState(() {
                _pruebas.add({
                  ...nuevaPruebaBase,
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'detalles': {
                    'distanciaCombate': nuevaPrueba.distanciaCombate,
                    'preparacionOfensiva': nuevaPrueba.preparacionOfensiva,
                    'eficienciaAtaque': nuevaPrueba.eficienciaAtaque,
                    'eficienciaContraataque': nuevaPrueba.eficienciaContraataque,
                    'entradaDistanciaCorta': nuevaPrueba.entradaDistanciaCorta,
                    'salidaCuerpoACuerpo': nuevaPrueba.salidaCuerpoACuerpo,
                  },
                });
              });
            },
          ),
        ),
      );
    } else if (testType == 'Psicologica') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaPsicologicaScreen(
            onGuardar: (nuevaPrueba) {
              setState(() {
                _pruebas.add({
                  ...nuevaPruebaBase,
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'detalles': {
                    'autocontrol': nuevaPrueba.autocontrol,
                    'combatividad': nuevaPrueba.combatividad,
                    'iniciativa': nuevaPrueba.iniciativa,
                  },
                });
              });
            },
          ),
        ),
      );
    } else if (testType == 'Reglas') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaReglasScreen(
            onGuardar: (nuevaPrueba) {
              setState(() {
                _pruebas.add({
                  ...nuevaPruebaBase,
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'detalles': {
                    'faltasTecnicas': nuevaPrueba.faltasTecnicas,
                    'conductaCombativa': nuevaPrueba.conductaCombativa,
                  },
                });
              });
            },
          ),
        ),
      );
    } else {
      setState(() {
        _pruebas.add(nuevaPruebaBase);
      });
    }
  }

  void _editTest(int index) {
    if (_pruebas[index]['tipo'] == 'Tecnica Detallada') {
      //_editarTecnicaDetallada(index);
    } else {
      _editarPruebaSimple(index);
    }
  }

  void _editarPruebaSimple(int index) {
    final controller = TextEditingController(
      text: _pruebas[index]['puntaje'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar ${_pruebas[index]['tipo']}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nuevo puntaje'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _pruebas[index]['puntaje'] = int.tryParse(controller.text) ?? 0;
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteTest(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar prueba de ${_pruebas[index]['tipo']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _pruebas.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prueba eliminada')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pruebas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarPruebas,
            tooltip: 'Guardar todas las pruebas',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () => _seleccionarFecha(context),
              child: IgnorePointer(
                child: TextFormField(
                  controller: _fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _pruebas.length,
                itemBuilder: (context, index) {
                  return _buildTestCard(index);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildAddButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(int index) {
    final prueba = _pruebas[index];

    IconData icon;
    Color color;

    switch (prueba['tipo']) {
      case 'Fisica':
        icon = Icons.fitness_center;
        color = Colors.black;
        break;
      case 'Tecnica Detallada':
        icon = Icons.circle_outlined;
        color = Colors.black;
        break;
      case 'Tactica':
        icon = Icons.adjust_rounded;
        color = Colors.black;
        break;
      case 'Psicologica':
        icon = Icons.psychology;
        color = Colors.black;
        break;
      case 'Reglas':
        icon = Icons.check_circle_outline;
        color = Colors.black;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, color: color, size: 30),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prueba['tipo'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Puntaje: ${prueba['puntaje']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editTest(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTest(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Prueba'),
        onPressed: () => _showAddTestDialog(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}