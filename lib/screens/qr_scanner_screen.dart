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
          // Determinar tipo de usuario
          String tipo = persona.esAdmin
              ? 'admin'
              : (persona.esLectura ? 'lectura' : 'usuario');
          await api.registrarAcceso(
            idpersona: persona.id,
            nombre: persona.nombres,
            telefono: persona.telefono,
            tipo: tipo,
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error registrando acceso: '
                  '${e is Exception ? e.toString() : e}',
                ),
                duration: Duration(seconds: 6),
              ),
            );
          }
          print('Error Supabase al registrar acceso: $e');
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Escanear QR'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              // Navegar al login_screen y limpiar el stack
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Escáner QR
          MobileScanner(
            onDetect: (capture) {
              if (_processing) return;
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String identificacion = barcodes.first.rawValue!;
                _handleScan(identificacion);
              }
            },
          ),
          // Overlay con instrucciones
          Positioned(
            bottom: 100,
            left: 24,
            right: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Apunta la cámara hacia el código QR',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'El escaneo se realizará automáticamente',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Indicador de procesamiento
          if (_processing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Procesando...',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
