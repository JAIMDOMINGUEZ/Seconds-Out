// viewmodels/registrar_entrenador_viewmodel.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secondsout/data/models/entrenador.dart';


class RegistrarEntrenadorViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> registrarEntrenador({
    required Entrenador entrenador,
    required String password,
    File? fotoPerfil,
  }) async {
    // 1. Crear usuario en Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: entrenador.correo,
      password: password,
    );

    final userId = userCredential.user!.uid;

    // 2. Subir imagen a Storage si existe
    String? fotoUrl;
    if (fotoPerfil != null) {
      final storageRef = _storage.ref().child('entrenadores/$userId/foto.jpg');
      await storageRef.putFile(fotoPerfil);
      fotoUrl = await storageRef.getDownloadURL();
    }

    // 3. Guardar datos en Firestore
    final data = entrenador.copyWith(
      remoteId: userId,
      fotoUrl: fotoUrl,
      ultimaSincronizacion: DateTime.now(),
      sincronizado: true,
    ).toRemoteMap();

    await _firestore.collection('usuarios').doc(userId).set(data);
  }
}
