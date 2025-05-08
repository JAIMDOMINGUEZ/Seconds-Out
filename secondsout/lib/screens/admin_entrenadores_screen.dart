import 'package:flutter/material.dart';
import 'editar_entrenador_screen.dart';
import 'registrar_entrenador_screen.dart';

class AdminEntrenadoresScreen extends StatefulWidget {
  const AdminEntrenadoresScreen({super.key});

  @override
  State<AdminEntrenadoresScreen> createState() => _AdminEntrenadoresScreenState();
}

class _AdminEntrenadoresScreenState extends State<AdminEntrenadoresScreen> {
  List<Map<String, dynamic>> _entrenadores = [
    {
      'id': '1',
      'nombre': 'Jaime Dominguez',
      'fechaNacimiento': '08/01/2001',
      'email': 'jaime@gmail.com',
    },
    {
      'id': '2',
      'nombre': 'Carlos Martinez',
      'fechaNacimiento': '15/05/1995',
      'email': 'carlos@gmail.com',
    },
    {
      'id': '3',
      'nombre': 'Juan Garcia',
      'fechaNacimiento': '22/11/1988',
      'email': 'juan@gmail.com',
    },
  ];

  Future<void> _mostrarDialogoConfirmacion(String id, String nombre) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar un botón para cerrar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de eliminar a $nombre?'),
                const SizedBox(height: 10),
                const Text('Esta acción no se puede deshacer.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _eliminarEntrenador(id);
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarEntrenador(String id) {
    setState(() {
      _entrenadores.removeWhere((entrenador) => entrenador['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entrenador eliminado'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _editarEntrenador(Map<String, dynamic> entrenadorActualizado) {
    setState(() {
      final index = _entrenadores.indexWhere((e) => e['id'] == entrenadorActualizado['id']);
      if (index != -1) {
        _entrenadores[index] = entrenadorActualizado;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entrenador actualizado'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Entrenadores'),
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
            const Text(
              'Administrar Entrenadores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _entrenadores.length,
                itemBuilder: (context, index) {
                  final entrenador = _entrenadores[index];
                  return _EntrenadorItem(
                    entrenador: entrenador,
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarEntrenadorScreen(
                            entrenador: entrenador,
                          ),
                        ),
                      );
                      if (result != null) {
                        _editarEntrenador(result);
                      }
                    },
                    onDelete: () {
                      _mostrarDialogoConfirmacion(entrenador['id'], entrenador['nombre']);
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

  Widget _buildAddButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Entrenador'),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrarEntrenadorScreen(),
            ),
          );
          if (result != null) {
            setState(() {
              _entrenadores.add({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                ...result
              });
            });
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

class _EntrenadorItem extends StatelessWidget {
  final Map<String, dynamic> entrenador;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EntrenadorItem({
    required this.entrenador,
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
      child: ListTile(
        leading: CircleAvatar(
          child: Text(entrenador['nombre'][0]), // Muestra la primera letra del nombre
        ),
        title: Text(
          entrenador['nombre'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entrenador['email']),
            Text('Nacimiento: ${entrenador['fechaNacimiento']}'),
          ],
        ),
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
    );
  }
}