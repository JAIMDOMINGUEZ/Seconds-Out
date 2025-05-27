import 'package:flutter/material.dart';
import 'detalles_sesion_screen.dart'; // Importar la pantalla de detalles

class AdministrarSesionesScreen extends StatefulWidget {
  final String nombreSemana;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  const AdministrarSesionesScreen({
    Key? key,
    required this.nombreSemana,
    required this.fechaInicio,
    required this.fechaFin,
  }) : super(key: key);

  @override
  _AdministrarSesionesScreenState createState() => _AdministrarSesionesScreenState();
}

class _AdministrarSesionesScreenState extends State<AdministrarSesionesScreen> {
  final List<String> _sesiones = [];
  int? _indiceEdicion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreSemana),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sesiones de entrenamiento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue.shade100,
                  label: Text(
                    '${_sesiones.length} sesiones',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _sesiones.isEmpty
                ? const Center(
              child: Text(
                'No hay sesiones agregadas',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _sesiones.length,
              itemBuilder: (context, index) {
                return _buildSesionItem(_sesiones[index], index);
              },
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

  Widget _buildAddButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Sesión'),
        onPressed: () => _mostrarDialogoSesion(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoSesion(BuildContext context, [int? index]) {
    String nombreSesion = '';
    final esEdicion = index != null;

    if (esEdicion) {
      nombreSesion = _sesiones[index];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esEdicion ? 'Editar sesión' : 'Agregar sesión'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nombre de la sesión',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => nombreSesion = value,
            controller: TextEditingController(text: nombreSesion),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (nombreSesion.isNotEmpty) {
                  setState(() {
                    if (esEdicion) {
                      _sesiones[index] = nombreSesion;
                    } else {
                      _sesiones.add(nombreSesion);
                    }
                  });
                  Navigator.pop(context);
                  _navegarADetallesSesion(context, nombreSesion);
                }
              },
              child: Text(esEdicion ? 'Guardar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSesionItem(String sessionName, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_view_day_rounded, color: Colors.blue),
        title: Text(sessionName),
        onTap: () => _navegarADetallesSesion(context, sessionName),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              _indiceEdicion = index;
              _mostrarDialogoSesion(context, index);
            } else if (value == 'delete') {
              setState(() {
                _sesiones.removeAt(index);
              });
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Editar'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  void _navegarADetallesSesion(BuildContext context, String nombreSesion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesSesionScreen(
          nombreSesion: nombreSesion,
        ),
      ),
    );
  }
}