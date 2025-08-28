import 'package:flutter/material.dart';
// Asegúrate de que la ruta de importación coincida con la estructura de tu proyecto.
// Reemplaza 'nombre_del_proyecto' con el nombre real de tu proyecto.
import 'package:control/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://dxdljgmfjtvcopmpayck.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4ZGxqZ21manR2Y29wbXBheWNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMDI1NzYsImV4cCI6MjA3MTg3ODU3Nn0.pKMgs19lxRqx-1-R0KkQq-CJMHPTO78C8FvtjC7yHT8',
  );
  runApp(const MyApp());
}

// void main() {
//   // La función runApp infla el widget principal y lo adjunta a la pantalla.
//   runApp(const MyApp());
// }

// MyApp es el widget raíz de tu aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es un widget que introduce varias funcionalidades
    // necesarias para una aplicación Material Design.
    return MaterialApp(
      // Desactiva el banner de "Debug" en la esquina superior derecha.
      debugShowCheckedModeBanner: false,

      // Título de la aplicación, usado por el sistema operativo.
      title: 'Control de Acceso',

      // Define el tema visual básico de la aplicación.
      theme: ThemeData(
        // Define el color primario que se usará en varios componentes como el AppBar.
        primarySwatch: Colors.blue,

        // Mejora la apariencia de la UI adaptándose a la densidad de la plataforma.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Establece el widget que se mostrará como pantalla de inicio de la aplicación.
      home: const LoginScreen(),
    );
  }
}
