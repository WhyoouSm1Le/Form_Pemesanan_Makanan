import '../data/menu_data.dart';

// Model = "wadah data" untuk satu pesanan.
// Semua informasi pesanan dibungkus jadi satu objek, jadi gampang dikirim
// ke widget lain (misalnya ke dialog checkout).
class Pesanan {
  final String nama;
  final String jenisKelamin;
  final List<String> menuDipilih;
  final List<String> tambahanDipilih;
  final int levelPedas;
  final bool antarKeRumah;

  const Pesanan({
    required this.nama,
    required this.jenisKelamin,
    required this.menuDipilih,
    required this.tambahanDipilih,
    required this.levelPedas,
    required this.antarKeRumah,
  });

  // Total harga makanan
  int get totalMenu =>
      menuDipilih.fold(0, (total, menu) => total + hargaMenu[menu]!);

  // Total harga tambahan
  int get totalTambahan => tambahanDipilih.fold(
        0,
        (total, tambahan) => total + hargaTambahan[tambahan]!,
      );

  // Total seluruh pesanan
  int get totalHarga => totalMenu + totalTambahan;
}
