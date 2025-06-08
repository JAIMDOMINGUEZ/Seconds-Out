import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/entrenador.dart';
import '../data/models/usuario.dart';
import 'editar_entrenador_screen.dart';
import 'registrar_entrenador_screen.dart';
import '../viewmodels/admin_entrenadores_view_model.dart';

class AdminEntrenadoresScreen extends StatefulWidget {
  const AdminEntrenadoresScreen({super.key});

  @override
  State<AdminEntrenadoresScreen> createState() => _AdminEntrenadoresScreenState();
}

class _AdminEntrenadoresScreenState extends State<AdminEntrenadoresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminEntrenadoresViewModel>().cargarEntrenadores();
    });
  }

  Future<void> _mostrarDialogoConfirmacion(int idEntrenador, String nombre) async {
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
              onPressed: () async {
                Navigator.of(context).pop();
                await context.read<AdminEntrenadoresViewModel>().eliminarEntrenador(idEntrenador);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminEntrenadoresViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Entrenadores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Entrenadores',
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
                  : viewModel.entrenadores.isEmpty
                  ? const Center(child: Text('No hay entrenadores registrados'))
                  : ListView.builder(
                itemCount: viewModel.entrenadores.length,
                itemBuilder: (context, index) {
                  final entrenador = viewModel.entrenadores[index];
                  return _EntrenadorItem(
                    entrenador: entrenador,
                    onEdit: () => _editarEntrenador(context, entrenador),
                    onDelete: () => _mostrarDialogoConfirmacion(
                        entrenador.idEntrenador,
                        entrenador.nombre

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

  Future<void> _editarEntrenador(BuildContext context, Entrenador entrenador) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEntrenadorScreen(
          entrenador: {
            'idEntrenador': entrenador.idEntrenador,
            'nombre': entrenador.nombre,
            'email': entrenador.correo,
            'fechaNacimiento': entrenador.fechaNacimiento,
            'contrasena': entrenador.contrasena,
          },
        ),
      ),
    );

    if (result != null && context.mounted) {
      final viewModel = context.read<AdminEntrenadoresViewModel>();
      final entrenadorActualizado = entrenador.copyWith(
        usuario: Usuario(
          idUsuario: entrenador.idUsuario,
          nombre: result['nombre'],
          correo: result['email'],
          contrasena: result['password'] ?? entrenador.contrasena,
          fechaNacimiento: result['fechaNacimiento'],
        ),
      );
      await viewModel.actualizarEntrenador(entrenadorActualizado);
    }
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
          if (result != null && context.mounted) {
            context.read<AdminEntrenadoresViewModel>().cargarEntrenadores();
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
  final Entrenador entrenador;
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
          backgroundColor: Colors.black,
          child: Text(
            entrenador.nombre[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),

        title: Text(
          entrenador.nombre,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entrenador.correo),
            Text('Nacimiento: ${entrenador.fechaNacimiento}'),
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