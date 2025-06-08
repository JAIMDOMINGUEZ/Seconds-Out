import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/atleta.dart';
import '../data/models/usuario.dart' show Usuario;
import '../viewmodels/admin_atletas_view_model.dart';
import 'editar_atleta_screen.dart';
import 'informacion_atleta_screen.dart';
import 'registrar_atleta_screen.dart';

class AdminAtletasScreen extends StatefulWidget {
  const AdminAtletasScreen({super.key});

  @override
  State<AdminAtletasScreen> createState() => _AdminAtletasScreenState();
}

class _AdminAtletasScreenState extends State<AdminAtletasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminAtletasViewModel>().cargarAtletas();
    });
  }

  Future<void> _mostrarConfirmacionEliminar(int idAtleta, String nombre) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de eliminar a ${"atleta.nombre"}?'),
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
              onPressed: () async {
                Navigator.of(context).pop();
                await context.read<AdminAtletasViewModel>().eliminarAtleta(idAtleta);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminAtletasViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Atletas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Atletas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.atletas.isEmpty
                  ? const Center(child: Text('No hay atletas registrados'))
                  : ListView.builder(
                itemCount: viewModel.atletas.length,
                itemBuilder: (context, index) {
                  final atleta = viewModel.atletas[index];
                  return _AtletaItem(
                    atleta: atleta,
                    onEdit: () => _editarAtleta(context, atleta),
                    onDelete: () => _mostrarConfirmacionEliminar(atleta.idAtleta,atleta.nombre),

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

  Future<void> _editarAtleta(BuildContext context, Atleta atleta) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarAtletaScreen(
          atleta: {
            'idAtleta': atleta.idAtleta,
            'nombre': atleta.nombre,
            'email': atleta.correo,
            'fechaNacimiento': atleta.fechaNacimiento,
            'contrasena': atleta.contrasena,
          },
        ),
      ),
    );

    if (result != null && context.mounted) {
      final viewModel = context.read<AdminAtletasViewModel>();
      final atletaActualizado = atleta.copyWith(
        usuario: Usuario(
          idUsuario: atleta.idUsuario,
          nombre: result['nombre'],
          correo: result['email'],
          contrasena: result['password'] ?? atleta.contrasena,
          fechaNacimiento: result['fechaNacimiento'],
        ),
      );
      await viewModel.actualizarAtleta(atletaActualizado);
    }
  }

  Widget _buildAddButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Atleta'),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrarAtletaScreen(),
            ),
          );
          if (result != null && context.mounted) {
            context.read<AdminAtletasViewModel>().cargarAtletas();
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
  final Atleta atleta;
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
              builder: (context) => InformacionAtletaScreen(atleta: {
                'idAtleta': atleta.idAtleta,
                'nombre': atleta.nombre,
                'email': atleta.correo,
                'fechaNacimiento': atleta.fechaNacimiento,
                'contrasena': atleta.contrasena,
              },
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              atleta.nombre[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            atleta.nombre,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
      ),
    );
  }
}