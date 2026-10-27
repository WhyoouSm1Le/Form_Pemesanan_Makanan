// Fungsi bantu (helper) yang tidak berhubungan dengan tampilan.
// Contoh: 15000 -> "Rp15.000"
String formatRupiah(int angka) {
  final teks = angka.toString();
  final buffer = StringBuffer();

  for (int i = 0; i < teks.length; i++) {
    buffer.write(teks[i]);

    final sisa = teks.length - i - 1;
    if (sisa > 0 && sisa % 3 == 0) {
      buffer.write('.');
    }
  }

  return 'Rp${buffer.toString()}';
}
