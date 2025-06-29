class Pajak {
  final double persen;
  final double nominalPotongan;
  final double totalKeselurusan;

  Pajak({
    required this.persen,
    required this.nominalPotongan,
    required this.totalKeselurusan,
  });

  factory Pajak.fromJson(Map<String, dynamic> json) {
    return Pajak(
      persen: (json['pesen_pajak'] ?? 0).toDouble(),
      nominalPotongan: (json['nilai_pajak'] ?? 0).toDouble(),
      totalKeselurusan: (json['total_setelah_pajak'] ?? 0).toDouble(),
    );
  }
}
