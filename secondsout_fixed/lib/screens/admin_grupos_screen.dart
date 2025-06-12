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
        backgroundColor: Colors.white,
        elevation: 4,
        foregroundColor: Colors.black, // texto y iconos blancos
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            if (viewModel.isLoading)
              const LinearProgressIndicator(color: Colors.black)
            else if (viewModel.grupos.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No hay grupos registrados.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: viewModel.grupos.length,
                  itemBuilder: (context, index) {
                    final grupo = viewModel.grupos[index];
                    return GrupoCard(
                      grupo: grupo,
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
            const SizedBox(height: 12),
            _buildAddButton(context),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildAddButton(BuildContext context) {
    final viewModel = context.read<GrupoViewModel>();
    return ElevatedButton.icon(
      icon: const Icon(Icons.group_add_rounded),
      label: const Text('Agregar Grupo'),
      onPressed: () => _showAddDialog(context, viewModel),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 6,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Nuevo Grupo', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      prefixIcon: Icon(Icons.group),
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
                      prefixIcon: Icon(Icons.format_list_numbered),
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // texto negro para cancelar
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // fondo negro para agregar
                foregroundColor: Colors.white,  // texto blanco
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Editar Grupo', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      prefixIcon: Icon(Icons.group),
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
                      prefixIcon: Icon(Icons.format_list_numbered),
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // texto negro para cancelar
              ),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // fondo negro para agregar
                foregroundColor: Colors.white,  // texto blanco
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final grupoEditado = Grupo(
                    id_grupo: grupo.id_grupo,  // MANTENER EL ID ORIGINAL
                    nombre: nombreController.text,
                    capacidadMaxima: int.parse(capacidadController.text),
                  );

                  Navigator.pop(context);
                  viewModel.actualizarGrupo(grupoEditado);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Grupo actualizado')),
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

  void _showDeleteDialog(BuildContext context, Grupo grupo) {
    final viewModel = context.read<GrupoViewModel>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Eliminar Grupo', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('¿Estás seguro de eliminar el grupo "${grupo.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              viewModel.eliminarGrupo(grupo.id_grupo!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Grupo eliminado')),
              );
            },
            child: const Text('Eliminar'),
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

  const GrupoCard({
    super.key,
    required this.grupo,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black12),
      ),
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black12,
                child: const Icon(
                  Icons.group,
                  color: Colors.black87,
                  size: 30,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  grupo.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    icon: const Icon(Icons.edit, color: Colors.black87),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    tooltip: 'Eliminar',
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
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
