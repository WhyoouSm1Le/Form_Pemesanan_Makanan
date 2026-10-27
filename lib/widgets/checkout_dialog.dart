import 'package:aplikasi_pemesanan_makanan/constant/app_colors.dart';
import 'package:flutter/material.dart';


import '../data/menu_data.dart';
import '../models/pesanan.dart';
import '../utils/format_rupiah.dart';

// Dialog ringkasan pesanan. Widget ini hanya menampilkan data;
// aksi saat tombol "Konfirmasi" ditekan diserahkan ke pemanggil lewat onConfirm.
class CheckoutDialog extends StatelessWidget {
  final Pesanan pesanan;
  final VoidCallback onConfirm;

  const CheckoutDialog({
    super.key,
    required this.pesanan,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Checkout Pesanan',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nama: ${pesanan.nama}'),
            Text('Jenis Kelamin: ${pesanan.jenisKelamin}'),
            const Divider(height: 24),

            const Text(
              'Makanan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...pesanan.menuDipilih.map(
              (menu) => _BarisHarga(nama: menu, harga: hargaMenu[menu]!),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tambahan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (pesanan.tambahanDipilih.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Tidak ada tambahan'),
              ),
            ...pesanan.tambahanDipilih.map(
              (tambahan) => _BarisHarga(
                nama: tambahan,
                harga: hargaTambahan[tambahan]!,
              ),
            ),

            const Divider(height: 24),

            Text('Level Pedas: ${pesanan.levelPedas}'),
            Text(
              'Pengantaran: '
              '${pesanan.antarKeRumah ? 'Antar ke rumah' : 'Ambil di tempat'}',
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Total Harga',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  formatRupiah(pesanan.totalHarga),
                  style: const TextStyle(
                    color: AppColors.ikon,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.utama,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // tutup dialog
            onConfirm(); // jalankan aksi dari pemanggil
          },
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }
}

// Satu baris "nama ........ harga". Private (diawali _) karena hanya dipakai di file ini.
class _BarisHarga extends StatelessWidget {
  final String nama;
  final int harga;

  const _BarisHarga({required this.nama, required this.harga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(nama)),
          Text(formatRupiah(harga)),
        ],
      ),
    );
  }
}
