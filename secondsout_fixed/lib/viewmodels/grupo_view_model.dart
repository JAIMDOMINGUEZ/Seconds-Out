  import 'package:flutter/material.dart';
  import '../data/models/atleta.dart';
  import '../repositories/atleta_repository.dart';
  import '../repositories/grupo_atleta_repository.dart';

  class GrupoViewModel extends ChangeNotifier {
    final AtletaRepository atletaRepository;
    final GrupoAtletaRepository grupoAtletaRepository;
    final int idGrupo;

    List<Atleta> atletasEnGrupo = [];
    List<Atleta> atletasDisponibles = [];

    GrupoViewModel({
      required this.atletaRepository,
      required this.grupoAtletaRepository,
      required this.idGrupo,
    });

    /// Cargar atletas del grupo y disponibles
    Future<void> cargarAtletas() async {
      final todos = await atletaRepository.obtenerTodosLosAtletas();
      final enGrupo = await grupoAtletaRepository.obtenerAtletasPorGrupo(idGrupo);

      final idsEnGrupo = enGrupo.map((e) => e.idAtleta).toSet();

      atletasEnGrupo = enGrupo;
      atletasDisponibles = todos.where((a) => !idsEnGrupo.contains(a.idAtleta)).toList();

      notifyListeners();
    }

    /// Agregar atleta al grupo
    Future<void> agregarAtleta(int idAtleta) async {
      await grupoAtletaRepository.agregarAtletaAGrupo(idGrupo, idAtleta);
      await cargarAtletas();
    }

    /// Eliminar atleta del grupo
    Future<void> eliminarAtleta(int idAtleta) async {
      await grupoAtletaRepository.eliminarAtletaDeGrupo(idGrupo, idAtleta);
      await cargarAtletas();
    }



  }
