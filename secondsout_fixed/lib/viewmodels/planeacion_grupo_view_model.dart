import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '/data/models/planeacion_grupo.dart';
import '../repositories/planeacion_grupo_repository.dart';

class PlaneacionGrupoViewModel extends ChangeNotifier {
  final PlaneacionGrupoRepository repository;

  List<PlaneacionGrupo> _planeacionGrupos = [];
  List<PlaneacionGrupo> get planeacionGrupos => _planeacionGrupos;

  PlaneacionGrupoViewModel({required Database database})
      : repository = PlaneacionGrupoRepository(database);

  Future<void> cargarPlaneacionGrupos() async {
    _planeacionGrupos = await repository.obtenerTodos();
    notifyListeners();
  }

  Future<void> agregarPlaneacionGrupo(PlaneacionGrupo pg) async {
    await repository.insertarPlaneacionGrupo(pg);
    await cargarPlaneacionGrupos();
  }

  Future<void> eliminarPlaneacionGrupo(int id) async {
    await repository.eliminarPorId(id);
    await cargarPlaneacionGrupos();
  }

  Future<void> actualizarPlaneacionGrupo(PlaneacionGrupo pg) async {
    await repository.actualizarPlaneacionGrupo(pg);
    await cargarPlaneacionGrupos();
  }
}
