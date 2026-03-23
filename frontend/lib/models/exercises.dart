class Exercise {
  final String tema;
  final String palabras;
  final String cuadricula;

  Exercise({
    required this.tema,
    required this.palabras,
    required this.cuadricula,
  });   

  factory Exercise.fromJson(Map<String, dynamic> json){
    return Exercise(
      tema: json['tema'],
      palabras: json['palabras'],
      cuadricula: json['cuadricula'],
    );
  }

}

