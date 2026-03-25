
class EjerciciosMatematicos {
  final List<Operacion> operaciones;

  EjerciciosMatematicos({required this.operaciones});


  factory EjerciciosMatematicos.fromJson(Map<String, dynamic> json) {
    return EjerciciosMatematicos(
      operaciones: List<Operacion>.from(
        json["operaciones"].map((x) => Operacion.fromJson(x)),
      ),
    );
  }
}


class Operacion {
  final String operacion;
  final int resultado;

  Operacion({
    required this.operacion,
    required this.resultado,
  });

  factory Operacion.fromJson(Map<String, dynamic> json) {
    return Operacion(
      operacion: json["operacion"],
      resultado: int.parse(json["resultado"].toString()),
    );
  }
}