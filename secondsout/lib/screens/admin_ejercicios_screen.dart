import 'package:flutter/material.dart';
import 'agregar_ejercicio_screen.dart';
import 'editar_ejercicio_screen.dart';
import 'informacion_ejercicio_screen.dart';
import 'agregar_ejercicio_screen.dart';

class AdminEjerciciosScreen extends StatefulWidget {
  const AdminEjerciciosScreen({super.key});

  @override
  State<AdminEjerciciosScreen> createState() => _AdminEjerciciosScreenState();
}

class _AdminEjerciciosScreenState extends State<AdminEjerciciosScreen> {
  List<Map<String, dynamic>> _ejercicios = [
    {
      'id': '1',
      'nombre': 'Costal',
      'tipo': 'Boxeo',
      'descripcion': 'Ejercicio de golpeo al costal',
    },
    {
      'id': '2',
      'nombre': 'Sombra',
      'tipo': 'Boxeo',
      'descripcion': 'Ejercicio de técnica en el aire',
    },
    {
      'id': '3',
      'nombre': 'Escuela de Combate Dirigido',
      'tipo': 'Boxeo',
      'descripcion': 'Ejercicio guiado por el entrenador',
    },
    {
      'id': '4',
      'nombre': 'Escuela de Boxeo',
      'tipo': 'Boxeo',
      'descripcion': 'Ejercicios técnicos básicos',
    },
    {
      'id': '5',
      'nombre': 'Saltar Cuerda',
      'tipo': 'Acondicionamiento',
      'descripcion': 'Ejercicio cardiovascular',
    },
  ];

  Future<void> _mostrarConfirmacionEliminar(String id, String nombre) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de eliminar el ejercicio "$nombre"?'),
                const SizedBox(height: 10),
                const Text('Esta acción no se puede deshacer.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _eliminarEjercicio(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarEjercicio(String id) {
    setState(() {
      _ejercicios.removeWhere((ejercicio) => ejercicio['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ejercicio eliminado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _actualizarEjercicio(Map<String, dynamic> ejercicioActualizado) {
    setState(() {
      final index = _ejercicios.indexWhere((e) => e['id'] == ejercicioActualizado['id']);
      if (index != -1) {
        _ejercicios[index] = ejercicioActualizado;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ejercicio actualizado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _agregarEjercicio(Map<String, dynamic> nuevoEjercicio) {
    setState(() {
      _ejercicios.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        ...nuevoEjercicio
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nuevo ejercicio registrado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Ejercicios'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              '9:30',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              child: ListView.builder(
                itemCount: _ejercicios.length,
                itemBuilder: (context, index) {
                  final ejercicio = _ejercicios[index];
                  return _EjercicioItem(
                    ejercicio: ejercicio,
                    onEdit: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarEjercicioScreen(
                            ejercicio: ejercicio,
                          ),
                        ),
                      );
                      if (resultado != null) {
                        _actualizarEjercicio(resultado);
                      }
                    },
                    onDelete: () => _mostrarConfirmacionEliminar(
                        ejercicio['id'],
                        ejercicio['nombre']
                    ),
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

  Widget _buildAddButton(BuildContext context) {
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
            _agregarEjercicio(resultado);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _EjercicioItem extends StatelessWidget {
  final Map<String, dynamic> ejercicio;
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
              builder: (context) => InformacionEjercicioScreen(ejercicio: ejercicio),
            ),
          );
        },
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForExerciseType(ejercicio['tipo']),
              color: Colors.blue,
            ),
          ),
          title: Text(
            ejercicio['nombre'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(ejercicio['tipo']),
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