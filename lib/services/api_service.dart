import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/persona.dart';

class ApiService {
  final supabase = Supabase.instance.client;

  // Registrar acceso en la tabla acceso
  Future<void> registrarAcceso({
    required int idpersona,
    required String nombre,
    required String telefono,
    required String tipo,
  }) async {
    final response = await supabase.from('acceso').insert({
      'idpersona': idpersona,
      'nombre': nombre,
      'telefono': telefono,
      'tipo': tipo,
      'fecha': DateTime.now().toIso8601String(),
      'hora':
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}',
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

  // Validar si la identificación ya existe
  Future<bool> existeIdentificacion(String identificacion) async {
    final response = await supabase
        .from('persona')
        .select('identificacion')
        .eq('identificacion', identificacion)
        .maybeSingle();
    return response != null;
  }

  // Validar si el email ya existe
  Future<bool> existeEmail(String email) async {
    final response = await supabase
        .from('persona')
        .select('email')
        .eq('email', email)
        .maybeSingle();
    return response != null;
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
