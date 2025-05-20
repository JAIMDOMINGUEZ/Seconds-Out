import 'package:flutter/material.dart';

import 'agregar_pruebas_screen.dart';
import 'editar_prueba_screen.dart';

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
    {
      'id': '1',
      'fecha': '05/12/25',
      'estado': 'BIEN',
      'pruebasCompletadas': ['Fisica', 'Tecnica Detallada', 'Tactica', 'Psicologica', 'Reglas']
    },
    {
      'id': '2',
      'fecha': '11/03/24',
      'estado': 'BIEN',
      'pruebasCompletadas': ['Fisica', 'Tactica', 'Reglas'] // Faltan 2
    },
    {
      'id': '3',
      'fecha': '02/18/23',
      'estado': 'REGULAR',
      'pruebasCompletadas': ['Fisica', 'Tecnica Detallada']
    },
    {
      'id': '4',
      'fecha': '09/30/21',
      'estado': 'BIEN',
      'pruebasCompletadas': ['Fisica', 'Tecnica Detallada', 'Tactica', 'Psicologica', 'Reglas']
    },
    {
      'id': '5',
      'fecha': '07/04/20',
      'estado': 'BIEN',
      'pruebasCompletadas': ['Tactica'] // Faltan 4
    },
  ];

  // Verifica si una prueba está completa
  bool _esPruebaCompleta(Map<String, dynamic> prueba) {
    final completadas = prueba['pruebasCompletadas'] as List<String>;
    return completadas.contains('Fisica') &&
        completadas.contains('Tecnica Detallada') &&
        completadas.contains('Tactica') &&
        completadas.contains('Psicologica') &&
        completadas.contains('Reglas');
  }

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

  void _editarPrueba(Map<String, dynamic> prueba, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPruebasScreen(
          prueba: {
            ...Map<String, dynamic>.from(prueba), // Copia todos los datos existentes
            'fecha': prueba['fecha'], // Asegura que la fecha se incluya
          },
          onGuardar: (pruebaEditada) {
            setState(() {
              _pruebas[index] = pruebaEditada;

              _pruebas[index]['estado'] = _esPruebaCompleta(pruebaEditada)
                  ? pruebaEditada['estado']
                  : 'PENDIENTE';
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prueba actualizada'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
            },
        ),
      ),
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
        ));
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
                  final estaCompleta = _esPruebaCompleta(prueba);
                  final estado = estaCompleta ? prueba['estado'] : 'PENDIENTE';

                  return _PruebaItem(
                    prueba: prueba,
                    estado: estado,
                    estaCompleta: estaCompleta,
                    onEdit: () => _editarPrueba(prueba, index),
                    onDelete: () => _mostrarDialogoConfirmacion(prueba['id']),
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
              builder: (context) => AgregarPruebasScreen(
                // Si necesitas pasar parámetros, debes primero modificar el constructor de PruebasScreen
                // para que los acepte:
                // atletaId: widget.atletaId,
                // nombreAtleta: widget.nombreAtleta,
              ),
            ),
          ).then((nuevaPrueba) {
            if (nuevaPrueba != null) {
              setState(() {
                _pruebas.add(nuevaPrueba);
              });
            }
          });
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
  final String estado;
  final bool estaCompleta;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PruebaItem({
    required this.prueba,
    required this.estado,
    required this.estaCompleta,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getColorByEstado(String estado, bool estaCompleta) {
    if (!estaCompleta) return Colors.grey;

    switch (estado) {
      case 'BIEN':
        return Colors.green;
      case 'REGULAR':
        return Colors.orange;
      case 'MAL':
        return Colors.red;
      case 'PENDIENTE':
        return Colors.grey;
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
            color: _getColorByEstado(estado, estaCompleta),
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
            Text('Estado: $estado'),
            if (!estaCompleta)
              Text(
                'Faltan pruebas: ${5 - (prueba['pruebasCompletadas'] as List).length}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
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