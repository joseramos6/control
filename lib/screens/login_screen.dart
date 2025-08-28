// En el método onPressed de un botón
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'qr_generator_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para obtener el texto de los campos de entrada
  final _identificacionController = TextEditingController();
  final _passwordController = TextEditingController();

  // Liberar los controladores cuando el widget se destruye para evitar fugas de memoria
  @override
  void dispose() {
    _identificacionController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final identificacion = _identificacionController.text;
    final password = _passwordController.text;
    final apiService = ApiService();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final persona = await apiService.login(identificacion, password);
      if (mounted) {
        Navigator.of(context).pop(); // Cierra el loader
        String mensaje;
        if (persona.esAdmin) {
          mensaje = '¡Bienvenido administrador!';
        } else {
          mensaje = 'Bienvenido usuario.';
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Inicio de sesión exitoso'),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrGeneratorScreen(
                        identificacion: persona.identificacion,
                        esAdmin: persona.esAdmin,
                        esLectura: persona.esLectura,
                      ),
                    ),
                  );
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cierra el loader
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error de inicio de sesión'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono o logo de la aplicación
              Icon(Icons.lock_person, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 32),

              // Campo de texto para la identificación (usuario)
              TextField(
                controller: _identificacionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Identificación',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de texto para la contraseña
              TextField(
                controller: _passwordController,
                obscureText: true, // Oculta el texto de la contraseña
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Botón de inicio de sesión
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
