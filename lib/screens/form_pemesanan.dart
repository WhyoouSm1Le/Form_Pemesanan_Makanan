import 'package:aplikasi_pemesanan_makanan/constant/app_colors.dart';
import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../models/pesanan.dart';
import '../utils/format_rupiah.dart';
import '../widgets/checkout_dialog.dart';
import '../widgets/section_title.dart';

// Halaman form pemesanan.
// StatefulWidget dipakai karena isi form berubah-ubah (pilihan user).
class FormPemesananScreen extends StatefulWidget {
  const FormPemesananScreen({super.key});

  @override
  State<FormPemesananScreen> createState() => _FormPemesananScreenState();
}

class _FormPemesananScreenState extends State<FormPemesananScreen> {
  // ---------- STATE (data yang berubah) ----------
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();

  String? _jenisKelamin;
  final List<String> _menuDipilih = [];
  double _levelPedas = 0;
  final List<String> _tambahanDipilih = [];
  bool _antarKeRumah = true;

  // Controller harus dibuang saat halaman ditutup supaya tidak boros memori.
  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  // ---------- LOGIKA ----------
  void _checkout() {
    if (!_formKey.currentState!.validate()) return;

    if (_jenisKelamin == null) {
      _tampilkanPesan('Silakan pilih jenis kelamin!');
      return;
    }

    if (_menuDipilih.isEmpty) {
      _tampilkanPesan('Silakan pilih menu makanan!');
      return;
    }

    // Bungkus semua input jadi satu objek Pesanan, lalu kirim ke dialog.
    final pesanan = Pesanan(
      nama: _namaController.text,
      jenisKelamin: _jenisKelamin!,
      menuDipilih: List.of(_menuDipilih),
      tambahanDipilih: List.of(_tambahanDipilih),
      levelPedas: _levelPedas.round(),
      antarKeRumah: _antarKeRumah,
    );

    showDialog(
      context: context,
      builder: (_) => CheckoutDialog(
        pesanan: pesanan,
        onConfirm: () => _tampilkanPesan('Pesanan berhasil dikirim!'),
      ),
    );
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // ---------- TAMPILAN ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Pemesanan Makanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildNama(),
              const SizedBox(height: 25),
              _buildJenisKelamin(),
              const SizedBox(height: 15),
              _buildMenu(),
              const SizedBox(height: 25),
              _buildLevelPedas(),
              const SizedBox(height: 25),
              _buildTambahan(),
              const SizedBox(height: 15),
              _buildPengantaran(),
              const SizedBox(height: 30),
              _buildTombolCheckout(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Tiap bagian form dipisah jadi method sendiri supaya build() mudah dibaca.

  Widget _buildHeader() {
    return const Column(
      children: [
        Center(
          child: Icon(Icons.restaurant_menu, size: 65, color: AppColors.ikon),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Silakan Isi Pesanan Anda',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildNama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('1. Nama Pelanggan'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _namaController,
          decoration: const InputDecoration(
            labelText: 'Masukkan nama lengkap',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama pelanggan wajib diisi!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildJenisKelamin() {
    // Daftar opsi dibuat dari list, jadi tidak perlu menulis RadioListTile dua kali.
    const pilihan = ['Laki-laki', 'Perempuan'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('2. Jenis Kelamin'),
        ...pilihan.map(
          (opsi) => RadioListTile<String>(
            title: Text(opsi),
            value: opsi,
            groupValue: _jenisKelamin,
            onChanged: (value) => setState(() => _jenisKelamin = value),
          ),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('3. Pilih Menu Makanan'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: hargaMenu.entries.map((entry) {
            final menu = entry.key;

            return FilterChip(
              label: Text('$menu\n${formatRupiah(entry.value)}'),
              selected: _menuDipilih.contains(menu),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _menuDipilih.add(menu);
                  } else {
                    _menuDipilih.remove(menu);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLevelPedas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('4. Pilih Level Pedas'),
        Slider(
          value: _levelPedas,
          min: 0,
          max: 10,
          divisions: 10,
          label: _levelPedas.round().toString(),
          activeColor: AppColors.utama,
          onChanged: (value) => setState(() => _levelPedas = value),
        ),
        Center(
          child: Text(
            'Level Pedas: ${_levelPedas.round()}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTambahan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('5. Pilihan Tambahan'),
        ...hargaTambahan.entries.map((entry) {
          final tambahan = entry.key;

          return CheckboxListTile(
            title: Text(tambahan),
            subtitle: Text(formatRupiah(entry.value)),
            value: _tambahanDipilih.contains(tambahan),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _tambahanDipilih.add(tambahan);
                } else {
                  _tambahanDipilih.remove(tambahan);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }

  Widget _buildPengantaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('6. Metode Pengantaran'),
        SwitchListTile(
          title: Text(_antarKeRumah ? 'Antar ke rumah' : 'Ambil di tempat'),
          subtitle: const Text('Aktif = antar ke rumah'),
          value: _antarKeRumah,
          activeColor: AppColors.utama,
          onChanged: (value) => setState(() => _antarKeRumah = value),
        ),
      ],
    );
  }

  Widget _buildTombolCheckout() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _checkout,
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.utama,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
