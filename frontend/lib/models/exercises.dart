class Exercise {
  final String tema;
  final List<String> palabras;

  Exercise({
    required this.tema,
    required this.palabras,
  });   

  factory Exercise.fromJson(Map<String, dynamic> json){
    return Exercise(
      tema: json['tema'],
      palabras: List<String>.from(json['palabras']),
    );
  }

}

