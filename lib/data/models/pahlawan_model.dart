class Pahlawan {
  final int id;
  final String text;
  final String createdAt;

  Pahlawan({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  factory Pahlawan.fromJson(Map<String, dynamic> json) {
    return Pahlawan(
      id: json['id'],
      text: json['text'],
      createdAt: json['created_at'],
    );
  }
}