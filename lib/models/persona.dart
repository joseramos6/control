class Persona {
  final int id;
  final String identificacion;
  final String nombres;
  final String telefono;
  final bool esAdmin;
  final bool esLectura;

  Persona({
    required this.id,
    required this.identificacion,
    required this.nombres,
    required this.telefono,
    required this.esAdmin,
    required this.esLectura,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      identificacion: json['identificacion'],
      nombres: json['nombres'],
      telefono: json['telefono'] ?? '',
      esAdmin: json['admin'],
      esLectura: json['lectura'],
    );
  }
}
