import 'package:flutter/material.dart';
import 'editar_atleta_screen.dart';
import 'informacion_atleta_screen.dart';
import 'registrar_atleta_screen.dart';

class AdminAtletasScreen extends StatefulWidget {
  const AdminAtletasScreen({super.key});

  @override
  State<AdminAtletasScreen> createState() => _AdminAtletasScreenState();
}

class _AdminAtletasScreenState extends State<AdminAtletasScreen> {
  List<Map<String, dynamic>> _atletas = [
    {
      'id': '1',
      'nombre': 'Juan Perez',
      'fechaNacimiento': '10/05/2000',
      'email': 'juan@email.com',
      'fotoUrl': null,
    },
    {
      'id': '2',
      'nombre': 'Carlos Martinez',
      'fechaNacimiento': '15/08/1999',
      'email': 'carlos@email.com',
      'fotoUrl': null,
    },
    {
      'id': '3',
      'nombre': 'Juan Garcia',
      'fechaNacimiento': '22/03/2001',
      'email': 'juan.g@email.com',
      'fotoUrl': null,
    },
    {
      'id': '4',
      'nombre': 'Jorge Alvarez',
      'fechaNacimiento': '03/12/1998',
      'email': 'jorge@email.com',
      'fotoUrl': null,
    },
    {
      'id': '5',
      'nombre': 'Pedro Torres',
      'fechaNacimiento': '30/07/2002',
      'email': 'pedro@email.com',
      'fotoUrl': null,
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
                Text('¿Estás seguro de eliminar a $nombre?'),
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
                _eliminarAtleta(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarAtleta(String id) {
    setState(() {
      _atletas.removeWhere((atleta) => atleta['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atleta eliminado'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _actualizarAtleta(Map<String, dynamic> atletaActualizado) {
    setState(() {
      final index = _atletas.indexWhere((a) => a['id'] == atletaActualizado['id']);
      if (index != -1) {
        _atletas[index] = atletaActualizado;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Atleta actualizado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _agregarAtleta(Map<String, dynamic> nuevoAtleta) {
    setState(() {
      _atletas.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        ...nuevoAtleta
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nuevo atleta registrado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Atletas'),
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
              'Administrar Atletas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _atletas.length,
                itemBuilder: (context, index) {
                  final atleta = _atletas[index];
                  return _AtletaItem(
                    atleta: atleta,
                    onEdit: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarAtletaScreen(
                            atleta: atleta,
                          ),
                        ),
                      );
                      if (resultado != null) {
                        _actualizarAtleta(resultado);
                      }
                    },
                    onDelete: () => _mostrarConfirmacionEliminar(atleta['id'], atleta['nombre']),
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
        label: const Text('Agregar Atleta'),
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrarAtletaScreen(),
            ),
          );
          if (resultado != null) {
            _agregarAtleta(resultado);
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

class _AtletaItem extends StatelessWidget {
  final Map<String, dynamic> atleta;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AtletaItem({
    required this.atleta,
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
              builder: (context) => InformacionAtletaScreen(atleta: atleta),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: atleta['fotoUrl'] != null
                ? NetworkImage(atleta['fotoUrl']) as ImageProvider
                : null,
            child: atleta['fotoUrl'] == null
                ? Text(atleta['nombre'][0])
                : null,
          ),
          title: Text(
            atleta['nombre'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(atleta['email']),
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
}