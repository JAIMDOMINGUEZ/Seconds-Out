import 'package:flutter/material.dart';
import 'package:secondsout/data/models/prueba_fisica.dart';
import 'package:secondsout/screens/prueba_psicologica_screen.dart';
import 'package:secondsout/screens/prueba_reglas_screen.dart';
import '../data/models/prueba_psicologica.dart';
import '../data/models/prueba_tactica.dart';
import '../data/models/pruebas_regla.dart';
import 'prueba_fisica_screen.dart';
import 'prueba_tactica_screen.dart';
import 'prueba_tecnica_detallada_screen.dart';
import 'editar_prueba_fisica_screen.dart';
import 'editar_prueba_tecnica_detallada_screen.dart';
import 'editar_prueba_tactica_screen.dart';
import 'editar_prueba_psicologica_screen.dart';
import 'editar_prueba_reglas_screen.dart';
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
      home: const AgregarPruebasScreen(),
    );
  }
}

class AgregarPruebasScreen extends StatefulWidget {
  const AgregarPruebasScreen({super.key});

  @override
  State<AgregarPruebasScreen> createState() => _AgregarPruebasScreenState();
}

class _AgregarPruebasScreenState extends State<AgregarPruebasScreen> {
  final List<Map<String, dynamic>> _pruebas = [
    {'tipo': 'Fisica', 'puntaje': 10, 'id': '1'},
    {
      'tipo': 'Tecnica Detallada',
      'puntaje': 8,
      'id': '2',
      'detalles': ['Distancia de Golpeo', 'Movilidad']
    },
    {'tipo': 'Tactica', 'puntaje': 10, 'id': '3'},
    {'tipo': 'Psicologica', 'puntaje': 5, 'id': '4'},
    {'tipo': 'Reglas', 'puntaje': 2, 'id': '5'},
  ];

  DateTime _fechaSeleccionada = DateTime.now();

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
      });
    }
  }

  void _guardarPruebas() {
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
        ),
      );
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
    // Verificación adicional por si acaso
    if (_pruebas.any((prueba) => prueba['tipo'] == testType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ya existe una prueba de tipo $testType'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

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
                  'tipo': 'Fisica',
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
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
                  'tipo': 'Tactica',
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
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
                  'tipo': 'Psicologica',
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
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
                  'tipo': 'Reglas',
                  'puntaje': nuevaPrueba.puntajeTotal,
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
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
        _pruebas.add({
          'tipo': testType,
          'puntaje': 0,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      });
    }
  }

  void _editTest(int index) {
    final prueba = _pruebas[index];
    final tipo = prueba['tipo'];
    final detalles = prueba['detalles'] ?? {};

    switch (tipo) {
      case 'Fisica':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPruebaFisicaScreen(
              pruebaExistente: PruebaFisica(
                rapidez: detalles['rapidez'] ?? 0,
                fuerza: detalles['fuerza'] ?? 0,
                reaccion: detalles['reaccion'] ?? 0,
                explosividad: detalles['explosividad'] ?? 0,
                coordinacion: detalles['coordinacion'] ?? 0, pruebaTecnicaId: 1, resistencia: detalles['resistencia'] ?? 0,
              ),
              onGuardar: (pruebaActualizada) {
                setState(() {
                  _pruebas[index] = {
                    ..._pruebas[index],
                    'puntaje': pruebaActualizada.puntajeTotal,
                    'detalles': {
                      'rapidez': pruebaActualizada.rapidez,
                      'fuerza': pruebaActualizada.fuerza,
                      'reaccion': pruebaActualizada.reaccion,
                      'explosividad': pruebaActualizada.explosividad,
                      'coordinacion': pruebaActualizada.coordinacion,
                      'resistencia': pruebaActualizada.resistencia,
                    },
                  };
                });
              },
            ),
          ),
        );
        break;

      case 'Tecnica Detallada':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPruebaTecnicaDetalladaScreen(
              pruebaExistente: _pruebas[index]['detalles'] is Map
                  ? Map<String, dynamic>.from(_pruebas[index]['detalles'])
                  : null,
              onGuardar: (pruebaActualizada) {
                setState(() {
                  _pruebas[index] = {
                    ..._pruebas[index],
                    'puntaje': pruebaActualizada['puntaje'],
                    'detalles': pruebaActualizada['detalles'],
                  };
                });
              },
            ),
          ),
        );
        break;

      case 'Tactica':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPruebaTacticaScreen(
              pruebaExistente: PruebaTactica(
                distanciaCombate: detalles['distanciaCombate'] ?? 0,
                preparacionOfensiva: detalles['preparacionOfensiva'] ?? 0,
                eficienciaAtaque: detalles['eficienciaAtaque'] ?? 0,
                eficienciaContraataque: detalles['eficienciaContraataque'] ?? 0,
                entradaDistanciaCorta: detalles['entradaDistanciaCorta'] ?? 0,
                salidaCuerpoACuerpo: detalles['salidaCuerpoACuerpo'] ?? 0, pruebaTecnicaId: 1,
              ),
              onGuardar: (pruebaActualizada) {
                setState(() {
                  _pruebas[index] = {
                    ..._pruebas[index],
                    'puntaje': pruebaActualizada.puntajeTotal,
                    'detalles': {
                      'distanciaCombate': pruebaActualizada.distanciaCombate,
                      'preparacionOfensiva': pruebaActualizada.preparacionOfensiva,
                      'eficienciaAtaque': pruebaActualizada.eficienciaAtaque,
                      'eficienciaContraataque': pruebaActualizada.eficienciaContraataque,
                      'entradaDistanciaCorta': pruebaActualizada.entradaDistanciaCorta,
                      'salidaCuerpoACuerpo': pruebaActualizada.salidaCuerpoACuerpo,
                    },
                  };
                });
              },
            ),
          ),
        );
        break;

      case 'Psicologica':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPruebaPsicologicaScreen(
              pruebaExistente: PruebaPsicologica(
                autocontrol: detalles['autocontrol'] ?? 0,
                combatividad: detalles['combatividad'] ?? 0,
                iniciativa: detalles['iniciativa'] ?? 0, pruebaTecnicaId: 1,
              ),
              onGuardar: (pruebaActualizada) {
                setState(() {
                  _pruebas[index] = {
                    ..._pruebas[index],
                    'puntaje': pruebaActualizada.puntajeTotal,
                    'detalles': {
                      'autocontrol': pruebaActualizada.autocontrol,
                      'combatividad': pruebaActualizada.combatividad,
                      'iniciativa': pruebaActualizada.iniciativa,
                    },
                  };
                });
              },
            ),
          ),
        );
        break;

      case 'Reglas':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditarPruebaReglasScreen(
              pruebaExistente: PruebaReglas(
                faltasTecnicas: detalles['faltasTecnicas'] ?? 0,
                conductaCombativa: detalles['conductaCombativa'] ?? 0, pruebaTecnicaId: 1,
              ),
              onGuardar: (pruebaActualizada) {
                setState(() {
                  _pruebas[index] = {
                    ..._pruebas[index],
                    'puntaje': pruebaActualizada.puntajeTotal,
                    'detalles': {
                      'faltasTecnicas': pruebaActualizada.faltasTecnicas,
                      'conductaCombativa': pruebaActualizada.conductaCombativa,
                    },
                  };
                });
              },
            ),
          ),
        );
        break;

      default:
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
        title: const Text('Agregar Pruebas'),
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
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
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

    // Definimos los iconos y colores para cada tipo de prueba
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