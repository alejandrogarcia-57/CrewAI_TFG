class Parejas {
  final List<Carta> cartas;

  Parejas({required this.cartas});

  factory Parejas.fromJson(Map<String, dynamic> json) {
  return Parejas(
    cartas: List<Carta>.from(
      json["cartas"].map((x) => Carta.fromJson(x)),
    )
  );
}
}



class Carta{
  final int id;
  final String emoji;
  final String par;

  Carta({
    required this.id,
    required this.emoji,
    required this.par
  });

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      id: json["id"],
      emoji: json["contenido"],
      par: json["par_id"]
    );
  }

}
