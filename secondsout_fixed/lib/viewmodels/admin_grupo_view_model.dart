import 'package:flutter/material.dart';
import 'package:secondsout_fixed/repositories/atleta_repository.dart';
import 'package:secondsout_fixed/repositories/grupo_atleta_repository.dart';
import '../repositories/grupo_repository.dart';
import '../data/models/grupo.dart';
import '../repositories/grupo_atleta_repository.dart';
class GrupoViewModel extends ChangeNotifier {
  final GrupoRepository _repository;

  List<Grupo> _grupos = [];
  bool _isLoading = false;

  GrupoViewModel(this._repository, {required GrupoAtletaRepository grupoAtletaRepository, required AtletaRepository atletaRepository});

  List<Grupo> get grupos => _grupos;
  bool get isLoading => _isLoading;

  Future<void> cargarGrupos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _grupos = await _repository.obtenerTodosLosGrupos();
    } catch (e) {
      debugPrint('Error al cargar grupos: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> agregarGrupo(Grupo grupo) async {
    try {
      await _repository.insertarGrupo(grupo);
      await cargarGrupos();
    } catch (e) {
      debugPrint('Error al agregar grupo: $e');
      rethrow;
    }
  }

  Future<void> eliminarGrupo(int id) async {
    try {
      await _repository.eliminarGrupo(id);
      _grupos.removeWhere((g) => g.id_grupo == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al eliminar grupo: $e');
      rethrow;
    }
  }

  Future<void> actualizarGrupo(Grupo grupo) async {
    try {
      final success = await _repository.actualizarGrupo(grupo);
      if (success) {
        final index = _grupos.indexWhere((g) => g.id_grupo == grupo.id_grupo);
        if (index != -1) {
          _grupos[index] = grupo;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error al actualizar grupo: $e');
      rethrow;
    }
  }

  Future<void> buscarGruposPorNombre(String nombre) async {
    try {
      _grupos = await _repository.buscarGruposPorNombre(nombre);
      notifyListeners();
    } catch (e) {
      debugPrint('Error al buscar grupos: $e');
      rethrow;
    }
  }

  void limpiarBusqueda() async {
    await cargarGrupos();
  }




}