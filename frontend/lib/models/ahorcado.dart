class Ahorcado {
  final String palabra;
  final List<Pista> pistas;
  final int longitud;

  Ahorcado({
    required this.palabra,
    required this.pistas,
    required this.longitud,
  });

  factory Ahorcado.fromJson(Map<String, dynamic> json) {

    var pistasMap = json['pistas'] as Map<String, dynamic>;

    return Ahorcado(
      palabra: json['palabra'],
      longitud: json['longitud'],
      pistas: pistasMap.entries.map((e) => Pista.fromEntry(e)).toList(),
    );
  }
}

class Pista{
  final String numero;
  final String texto;

  Pista({required this.numero, required this.texto});

  factory Pista.fromEntry(MapEntry<String, dynamic> entry){
    return Pista(
      numero: entry.key,
      texto: entry.value,
    );
  }
}
