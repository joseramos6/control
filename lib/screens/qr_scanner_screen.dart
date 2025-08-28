import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';
import 'register_persona_screen.dart';
import 'ingreso_exitoso_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _processing = false;

  Future<void> _handleScan(String identificacion) async {
    if (_processing) return;
    setState(() => _processing = true);
    final api = ApiService();
    // Limpieza del valor escaneado
    final cleanId = identificacion.trim();
    print('QR escaneado: "$cleanId"');
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('QR escaneado: "$cleanId"')));
    }
    try {
      final persona = await api.buscarPersonaPorIdentificacion(cleanId);
      if (persona != null) {
        try {
          await api.registrarAcceso(persona.identificacion);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error registrando acceso: \\${e.toString()}'),
              ),
            );
          }
        }
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => IngresoExitosoScreen(persona: persona),
            ),
          );
        }
      } else {
        if (mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('No registrado'),
              content: const Text(
                'La persona no está registrada. ¿Desea registrarla?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPersonaScreen(),
                      ),
                    );
                  },
                  child: const Text('Registrar'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
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
    } finally {
      // Solo liberar el procesamiento después de que el usuario cierre el diálogo
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_processing) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String identificacion = barcodes.first.rawValue!;
            _handleScan(identificacion);
          }
        },
      ),
    );
  }
}
