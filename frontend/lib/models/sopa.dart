class Sopa {
  final String tema;
  final String palabras;
  final String cuadricula;

  Sopa({
    required this.tema,
    required this.palabras,
    required this.cuadricula,
  });   

  factory Sopa.fromJson(Map<String, dynamic> json){
    return Sopa(
      tema: json['tema'],
      palabras: json['palabras'],
      cuadricula: json['cuadricula'],
    );
  }

}

