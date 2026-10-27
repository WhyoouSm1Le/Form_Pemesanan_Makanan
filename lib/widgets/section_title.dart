import 'package:flutter/material.dart';

// Judul tiap bagian form ("1. Nama Pelanggan", dst).
// Sebelumnya kode Text(... bold) ditulis berulang 6 kali, sekarang cukup satu widget.
class SectionTitle extends StatelessWidget {
  final String teks;

  const SectionTitle(this.teks, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      teks,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
