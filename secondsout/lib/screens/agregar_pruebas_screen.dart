import 'package:flutter/material.dart';
import 'package:secondsout/data/models/prueba_fisica.dart';
import 'package:secondsout/screens/prueba_psicologica_screen.dart';
import 'package:secondsout/screens/prueba_reglas_screen.dart';
import 'prueba_fisica_screen.dart';
import 'prueba_tactica.dart';

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
      home: const PruebasScreen(),
    );
  }
}

class PruebasScreen extends StatefulWidget {
  const PruebasScreen({super.key});

  @override
  State<PruebasScreen> createState() => _PruebasScreenState();
}

class _PruebasScreenState extends State<PruebasScreen> {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar tipo de prueba'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: testTypes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(testTypes[index]),
                  onTap: () {
                    Navigator.pop(context);
                    _addNewTest(testTypes[index]);
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
                ;
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
    }else if(testType == 'Psicologica'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaPsicologicaScreen(
            onGuardar: (nuevaPrueba) {
              // Lógica para guardar
            },
          ),
        ),
      );



  }else if(testType == 'Reglas'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PruebaReglasScreen(
            onGuardar: (nuevaPrueba) {
              // Lógica para guardar
            },
          ),
        ),
      );
  }
    else {
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
                _pruebas[index]['puntaje'] =
                    int.tryParse(controller.text) ?? 0;
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

  int _calcularPuntaje(List<String> tecnicas) {
    return tecnicas.length * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Pruebas'),
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
          // Campo de fecha agregado aquí
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
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prueba['tipo'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Puntaje: ${prueba['puntaje']}',
                        style: const TextStyle(fontSize: 16),
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
            if (prueba['detalles'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Técnicas: ${(prueba['detalles'] as List).join(', ')}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
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

