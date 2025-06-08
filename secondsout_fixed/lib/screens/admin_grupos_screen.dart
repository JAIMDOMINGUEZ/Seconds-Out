import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/admin_grupo_view_model.dart';
import '../data/models/grupo.dart';
import '/screens/detalle_grupo_screen.dart';

class AdminGruposScreen extends StatefulWidget {
  const AdminGruposScreen({super.key});

  @override
  State<AdminGruposScreen> createState() => _AdminGruposScreenState();
}

class _AdminGruposScreenState extends State<AdminGruposScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrupoViewModel>().cargarGrupos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GrupoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Grupos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (viewModel.isLoading)
              const LinearProgressIndicator()
            else if (viewModel.grupos.isEmpty)
              const Center(child: Text('No hay grupos registrados.'))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.grupos.length,
                  itemBuilder: (context, index) {
                    final grupo = viewModel.grupos[index];
                    return GrupoCard(
                      grupo: grupo,
                      cantidadMiembros: 1,
                      onEdit: () => _showEditDialog(context, grupo),
                      onDelete: () => _showDeleteDialog(context, grupo),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoGrupoScreen(grupo: grupo),
                          ),
                        );
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
    final viewModel = context.read<GrupoViewModel>();
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Agregar Grupo'),
        onPressed: () => _showAddDialog(context, viewModel),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, GrupoViewModel viewModel) {
    final nombreController = TextEditingController();
    final capacidadController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Grupo'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del grupo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el nombre del grupo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: capacidadController,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad máxima',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la capacidad';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Debe ser un número';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final nuevoGrupo = Grupo(
                    nombre: nombreController.text,
                    capacidadMaxima: int.parse(capacidadController.text),
                  );

                  Navigator.pop(context);
                  viewModel.agregarGrupo(nuevoGrupo);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Grupo agregado')),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Grupo grupo) {
    final viewModel = context.read<GrupoViewModel>();
    final nombreController = TextEditingController(text: grupo.nombre);
    final capacidadController = TextEditingController(text: grupo.capacidadMaxima.toString());
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Grupo'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del grupo',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese el nombre del grupo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: capacidadController,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad máxima',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese la capacidad';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Debe ser un número';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final grupoActualizado = grupo.copyWith(
                    nombre: nombreController.text,
                    capacidadMaxima: int.parse(capacidadController.text),
                  );

                  Navigator.pop(context);
                  viewModel.actualizarGrupo(grupoActualizado);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Grupo actualizado')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Grupo grupo) {
    final viewModel = context.read<GrupoViewModel>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Grupo'),
        content: Text('¿Estás seguro de eliminar el grupo "${grupo.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.eliminarGrupo(grupo.id_grupo!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grupo eliminado')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final int cantidadMiembros;
  const GrupoCard({
    super.key,
    required this.grupo,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.cantidadMiembros,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grupo.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => [
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
            ],
          ),
        ),
      ),
    );
  }
}