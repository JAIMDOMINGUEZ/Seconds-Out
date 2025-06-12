import 'package:flutter/material.dart';
import '/data/models/sesion.dart';
import '../repositories/sesion_repository.dart';

class SesionViewModel extends ChangeNotifier {
  final SesionRepository _repositorio;
  final int idSemana;

  SesionViewModel(this._repositorio, this.idSemana) {
    cargarSesiones();
  }

  List<Sesion> _sesiones = [];
  List<Sesion> get sesiones => _sesiones;

  bool _cargando = false;
  bool get cargando => _cargando;

  Future<void> cargarSesiones() async {
    _cargando = true;
    notifyListeners();

    _sesiones = await _repositorio.obtenerSesionesPorSemana(idSemana);

    _cargando = false;
    notifyListeners();
  }

  Future<int> agregarSesion(String nombre) async {
    final nuevaSesion = Sesion(nombre: nombre, id_semana: idSemana);
    final id = await _repositorio.insertarSesion(nuevaSesion);
    await cargarSesiones(); // Actualizar lista
    return id;
  }


  Future<void> editarSesion(int idSesion, String nuevoNombre) async {
    final sesionExistente = _sesiones.firstWhere((s) => s.id_sesion == idSesion);
    final sesionEditada = Sesion(
      id_sesion: idSesion,
      id_semana: sesionExistente.id_semana,
      nombre: nuevoNombre,
    );
    await _repositorio.actualizarSesion(sesionEditada);
    await cargarSesiones();
  }

  Future<void> eliminarSesion(int idSesion) async {
    await _repositorio.eliminarSesion(idSesion);
    await cargarSesiones();
  }
}
