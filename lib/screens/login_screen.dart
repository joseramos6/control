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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QrGeneratorScreen(
              identificacion: persona.identificacion,
              nombre: persona.nombres,
              esAdmin: persona.esAdmin,
              esLectura: persona.esLectura,
            ),
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
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icono principal
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Título
                Text(
                  'Control de Acceso',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa tus credenciales para continuar',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 48),

                // Tarjeta de login
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Campo de identificación
                        TextField(
                          controller: _identificacionController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Identificación',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Campo de contraseña
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botón de login
                        FilledButton.icon(
                          onPressed: _handleLogin,
                          icon: const Icon(Icons.login),
                          label: const Text('Iniciar Sesión'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
