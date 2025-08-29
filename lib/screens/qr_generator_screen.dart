import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'qr_scanner_screen.dart';
import 'register_persona_screen.dart';

class QrGeneratorScreen extends StatelessWidget {
  final String identificacion;
  final String? nombre;
  final bool esAdmin;
  final bool esLectura;

  const QrGeneratorScreen({
    super.key,
    required this.identificacion,
    this.nombre,
    this.esAdmin = false,
    this.esLectura = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    // Estilo moderno para botones
    final buttonStyle = FilledButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );

    final outlinedButtonStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 52),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
    );

    if (esAdmin) {
      actions.addAll([
        FilledButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Escanear Código'),
          style: buttonStyle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Registrar Persona'),
          style: outlinedButtonStyle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPersonaScreen(),
              ),
            );
          },
        ),
      ]);
    } else if (esLectura) {
      actions.add(
        FilledButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Escanear Código'),
          style: buttonStyle,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Mi Código QR"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tarjeta principal del QR
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Icono de perfil
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mensaje de bienvenida
                        if (nombre != null && nombre!.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                '¡Hola, $nombre!',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Este es tu código QR personal',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),

                        // Código QR con fondo blanco
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 2,
                            ),
                          ),
                          child: QrImageView(
                            data: identificacion,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Información de identificación
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Identificación',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                identificacion,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (actions.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  ...actions,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
