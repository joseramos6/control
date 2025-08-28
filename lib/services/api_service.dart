import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/persona.dart';

class ApiService {
  final supabase = Supabase.instance.client;

  // Registrar acceso en la tabla acceso
  Future<void> registrarAcceso(String identificacion) async {
    final response = await supabase.from('acceso').insert({
      'identificacion': identificacion,
      'fecha_hora': DateTime.now().toIso8601String(),
    });
    if (response.error != null) {
      throw Exception('Error al registrar acceso: ${response.error!.message}');
    }
  }

  // Buscar persona por identificación
  Future<Persona?> buscarPersonaPorIdentificacion(String identificacion) async {
    final response = await supabase
        .from('persona')
        .select()
        .eq('identificacion', identificacion)
        .maybeSingle();
    if (response == null) return null;
    return Persona.fromJson(response);
  }

  // Función para iniciar sesión usando Supabase
  Future<Persona> login(String identificacion, String password) async {
    // Cifrar la contraseña con SHA-256
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    final response = await supabase
        .from('persona')
        .select()
        .eq('identificacion', identificacion)
        .eq('password', digest.toString())
        .maybeSingle();

    if (response == null) {
      throw Exception('Identificación o contraseña incorrecta');
    }
    return Persona.fromJson(response);
  }

  // Registrar una nueva persona en la base de datos
  Future<void> registrarPersona({
    required String identificacion,
    required String nombres,
    required String direccion,
    required String telefono,
    required String email,
    required String password,
    bool esAdmin = false,
    bool esLectura = false,
  }) async {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    final response = await supabase.from('persona').insert({
      'identificacion': identificacion,
      'nombres': nombres,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'password': digest.toString(),
      'admin': esAdmin,
      'lectura': esLectura,
    });
    if (response.error != null) {
      throw Exception('Error al registrar persona: ${response.error!.message}');
    }
  }
}
