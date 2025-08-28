import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'qr_scanner_screen.dart';
import 'register_persona_screen.dart';

class QrGeneratorScreen extends StatelessWidget {
  final String identificacion;
  final bool esAdmin;
  final bool esLectura;

  const QrGeneratorScreen({
    super.key,
    required this.identificacion,
    this.esAdmin = false,
    this.esLectura = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (esAdmin) {
      actions.addAll([
        ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Escanear código'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          icon: const Icon(Icons.person_add),
          label: const Text('Registrar persona'),
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
        ElevatedButton.icon(
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Escanear código'),
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
      appBar: AppBar(title: const Text("Mi Código QR")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: identificacion,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 32),
            ...actions,
          ],
        ),
      ),
    );
  }
}
