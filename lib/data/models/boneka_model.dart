class Boneka {
  final int id;
  final String text;
  final String createdAt;

  Boneka({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  factory Boneka.fromJson(Map<String, dynamic> json) {
    return Boneka(
      id: json['id'],
      text: json['text'],
      createdAt: json['created_at'],
    );
  }
}