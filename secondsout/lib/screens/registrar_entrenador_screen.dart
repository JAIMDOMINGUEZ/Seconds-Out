// views/registrar_entrenador_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondsout/viewmodels/registrar_entrenador_viewmodel.dart';
import '../data/models/entrenador.dart';

import '/viewmodels/registrar_entrenador_viewmodel.dart';

class RegistrarEntrenadorScreen extends StatefulWidget {
  @override
  _RegistrarEntrenadorScreenState createState() => _RegistrarEntrenadorScreenState();
}

class _RegistrarEntrenadorScreenState extends State<RegistrarEntrenadorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _fotoPerfil;

  Future<void> _seleccionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoPerfil = File(pickedFile.path);
      });
    }
  }

  void _guardarEntrenador() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = RegistrarEntrenadorViewModel();
      final entrenador = Entrenador(
        nombre: _nombreController.text.trim(),
        correo: _emailController.text.trim(),
        fechaNacimiento: _fechaNacimientoController.text.trim(),
        contrasena: _passwordController.text,
        ultimaSincronizacion: DateTime.now(),
        sincronizado: false,
      );

      try {
        await viewModel.registrarEntrenador(
          entrenador: entrenador,
          password: _passwordController.text,
          fotoPerfil: _fotoPerfil,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entrenador registrado exitosamente'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _fechaNacimientoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Entrenador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _seleccionarFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
                  child: _fotoPerfil == null ? const Icon(Icons.add_a_photo, size: 50) : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Ingrese el correo' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(labelText: 'Fecha de nacimiento'),
                validator: (value) => value!.isEmpty ? 'Ingrese la fecha de nacimiento' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Ingrese la contraseña' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardarEntrenador,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
