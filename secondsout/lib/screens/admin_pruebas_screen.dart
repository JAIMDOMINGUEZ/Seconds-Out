import 'package:flutter/material.dart';

import 'agregar_pruebas_screen.dart';

class AdminPruebasScreen extends StatefulWidget {
  final String atletaId;
  final String nombreAtleta;

  const AdminPruebasScreen({
    super.key,
    required this.atletaId,
    required this.nombreAtleta,
  });

  @override
  State<AdminPruebasScreen> createState() => _AdminPruebasScreenState();
}

class _AdminPruebasScreenState extends State<AdminPruebasScreen> {
  List<Map<String, dynamic>> _pruebas = [
    {'id': '1', 'fecha': '05/12/25', 'estado': 'BIEN'},
    {'id': '2', 'fecha': '11/03/24', 'estado': 'BIEN' },
    {'id': '3', 'fecha': '02/18/23', 'estado': 'REGULAR' },
    {'id': '4', 'fecha': '09/30/21', 'estado': 'BIEN' },
    {'id': '5', 'fecha': '07/04/20', 'estado': 'BIEN'},
  ];

  Future<void> _mostrarDialogoConfirmacion(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de eliminar esta prueba?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _eliminarPrueba(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _eliminarPrueba(String id) {
    setState(() {
      _pruebas.removeWhere((prueba) => prueba['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prueba eliminada'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pruebas de ${widget.nombreAtleta}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              'ID: ${widget.atletaId}',
              style: const TextStyle(fontSize: 16),
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
              'Historial de Pruebas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _pruebas.length,
                itemBuilder: (context, index) {
                  final prueba = _pruebas[index];
                  return _PruebaItem(
                    prueba: prueba,
                    onEdit: () {
                      // Navegar a pantalla de edición
                    },
                    onDelete: () {
                      _mostrarDialogoConfirmacion(prueba['id']);
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
        label: const Text('Agregar Prueba'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PruebasScreen(
                // Si necesitas pasar parámetros, debes primero modificar el constructor de PruebasScreen
                // para que los acepte:
                // atletaId: widget.atletaId,
                // nombreAtleta: widget.nombreAtleta,
              ),
            ),
          );
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

class _PruebaItem extends StatelessWidget {
  final Map<String, dynamic> prueba;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PruebaItem({
    required this.prueba,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getColorByEstado(String estado) {
    switch (estado) {
      case 'BIEN':
        return Colors.green;
      case 'REGULAR':
        return Colors.orange;
      case 'MAL':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getColorByEstado(prueba['estado']),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.assignment, color: Colors.white),
        ),
        title: Text(
          prueba['fecha'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Estado: ${prueba['estado']}'),
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