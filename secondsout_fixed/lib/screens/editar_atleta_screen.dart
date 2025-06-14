import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../data/models/atleta.dart';
import '../viewmodels/admin_atletas_view_model.dart';
import '/data/models/atleta.dart';

class EditarAtletaScreen extends StatefulWidget {
  final Map<String, dynamic> atleta;

  const EditarAtletaScreen({super.key, required this.atleta});

  @override
  State<EditarAtletaScreen> createState() => _EditarAtletaScreenState();
}

class _EditarAtletaScreenState extends State<EditarAtletaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _fechaNacimientoController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordChanged = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.atleta['nombre']);
    _fechaNacimientoController = TextEditingController(text: widget.atleta['fechaNacimiento']);
    _emailController = TextEditingController(text: widget.atleta['email']);
    _passwordController = TextEditingController(text: widget.atleta['contrasena']);
    _confirmPasswordController = TextEditingController(text: widget.atleta['contrasena']);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaNacimientoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimientoController.text =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _mostrarOpcionesFoto() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Atleta'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 30),

              // Foto de perfil
              Center(
                child: GestureDetector(
                  onTap: _mostrarOpcionesFoto,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Icon(Icons.person, size: 50),
                        backgroundColor: Colors.white,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(

                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor ingrese el nombre' : null,
              ),
              const SizedBox(height: 20),

              // Fecha de nacimiento
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor seleccione la fecha' : null,
              ),
              const SizedBox(height: 20),

              // Correo
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Ingrese un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  if (value != '********') {
                    setState(() {
                      _passwordChanged = true;
                    });
                  }
                },
                validator: (value) {
                  if (_passwordChanged) {
                    if (value == null || value.isEmpty) return 'Por favor ingrese una contraseña';
                    if (value.length < 8) return 'Debe tener al menos 8 caracteres';
                    if (!value.contains(RegExp(r'[A-Z]'))) return 'Debe contener una mayúscula';
                    if (!value.contains(RegExp(r'[0-9]'))) return 'Debe contener un número';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (_passwordChanged && value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Procesar los datos editados
                          final atletaActualizado = {
                            'nombre': _nombreController.text,
                            'fechaNacimiento': _fechaNacimientoController.text,
                            'email': _emailController.text,
                            'password': _passwordChanged ? _passwordController.text : null,

                          };

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Atleta actualizado exitosamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context, atletaActualizado);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
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
