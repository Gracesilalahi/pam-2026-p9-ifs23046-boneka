class ApiConstants {
  // Kita hapus tanda miring di akhir baseUrl agar lebih aman saat digabungkan
  static const String baseUrl = "https://pam-2026-p9-ifs23046-be.s1if.life:8080";

  // Sesuaikan dengan route yang ada di Flask kamu (biasanya pakai /api/boneka)
  static const String bonekas = "$baseUrl/api/boneka";
  static const String generate = "$baseUrl/api/boneka/generate";
}