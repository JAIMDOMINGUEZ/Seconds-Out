import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'detalles_sesion_screen.dart';
import '/data/models/sesion.dart';
import '../viewmodels/admin_sesion_view_model.dart';
import '../repositories/sesion_repository.dart';

class AdministrarSesionesScreen extends StatelessWidget {
  final String nombreSemana;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int idSemana;

  const AdministrarSesionesScreen({
    Key? key,
    required this.nombreSemana,
    required this.fechaInicio,
    required this.fechaFin,
    required this.idSemana,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => SesionViewModel(SesionRepository(database), idSemana)..cargarSesiones(),
      child: _AdministrarSesionesContent(nombreSemana: nombreSemana),
    );
  }
}

class _AdministrarSesionesContent extends StatelessWidget {
  final String nombreSemana;

  const _AdministrarSesionesContent({
    Key? key,
    required this.nombreSemana,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SesionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black), // Ícono blanco
        title: Text(nombreSemana),
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
                    color: Colors.black,
                  ),
                ),
                Chip(
                  backgroundColor: Colors.grey,
                  label: Text(
                    '${viewModel.sesiones.length} sesiones',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: viewModel.sesiones.isEmpty
                ? const Center(
              child: Text(
                'No hay sesiones agregadas',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: viewModel.sesiones.length,
              itemBuilder: (context, index) {
                final sesion = viewModel.sesiones[index];
                return _buildSesionItem(context, viewModel, sesion, index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildAddButton(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, SesionViewModel viewModel) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Sesión'),
        onPressed: () => _mostrarDialogoSesion(context, viewModel),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildSesionItem(BuildContext context, SesionViewModel viewModel, Sesion sesion, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_view_day_rounded, color: Colors.black),
        title: Text(sesion.nombre),
        onTap: () => _navegarADetallesSesion(context, sesion.nombre, sesion.id_sesion!),

          trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              _mostrarDialogoSesion(context, viewModel, sesion: sesion);
            } else if (value == 'delete') {
              viewModel.eliminarSesion(sesion.id_sesion!);
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

  void _mostrarDialogoSesion(BuildContext context, SesionViewModel viewModel, {Sesion? sesion}) {
    final esEdicion = sesion != null;
    final controller = TextEditingController(text: sesion?.nombre ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esEdicion ? 'Editar sesión' : 'Agregar sesión'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nombre de la sesión',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                final nombre = controller.text.trim();
                if (nombre.isNotEmpty) {
                  if (esEdicion) {
                    await viewModel.editarSesion(sesion!.id_sesion!, nombre);
                  } else {
                    //await viewModel.agregarSesion(nombre);
                  }
                  final nuevoId = await viewModel.agregarSesion(nombre);
                  Navigator.pop(context);
                  _navegarADetallesSesion(context, nombre, nuevoId);
                }
              },
              child: Text(
                esEdicion ? 'Guardar' : 'Agregar',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navegarADetallesSesion(BuildContext context, String nombreSesion, int id_sesion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesSesionScreen(
          idSesion: id_sesion, // Replace with actual ID
          nombreSesion: nombreSesion,
        ),
      ),
    );
  }
}
