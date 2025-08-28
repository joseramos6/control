class Persona {
  final int id;
  final String identificacion;
  final String nombres;
  final bool esAdmin;
  final bool esLectura;

  Persona({
    required this.id,
    required this.identificacion,
    required this.nombres,
    required this.esAdmin,
    required this.esLectura,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      identificacion: json['identificacion'],
      nombres: json['nombres'],
      esAdmin: json['admin'],
      esLectura: json['lectura'],
    );
  }
}
