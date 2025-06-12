import '/data/models/prueba_fisica.dart';

class PruebaFisicaRepository {
  final List<PruebaFisica> _storage = [];

  Future<List<PruebaFisica>> obtenerPruebas() async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('[Repository] Obteniendo pruebas. Total: ${_storage.length}');
    for (final prueba in _storage) {
      print('  - ${prueba.toJson()}');
    }
    return List.from(_storage);
  }

  Future<void> insertarPrueba(PruebaFisica prueba) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _storage.add(prueba);
    print('[Repository] Prueba insertada: ${prueba.toJson()}');
  }

  Future<void> actualizarPrueba(PruebaFisica prueba) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _storage.indexWhere((p) => p.id_prueba == prueba.id_prueba);
    if (index >= 0) {
      _storage[index] = prueba;
      print('[Repository] Prueba actualizada: ${prueba.toJson()}');
    } else {
      print('[Repository] Error: Prueba no encontrada para actualizar con id: ${prueba.id_prueba}');
      throw Exception('Prueba no encontrada');
    }
  }

  Future<void> eliminarPrueba(int idPrueba) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _storage.removeWhere((p) => p.id_prueba == idPrueba);
    print('🗑️ [Repository] Prueba eliminada con id: $idPrueba');
  }
}
