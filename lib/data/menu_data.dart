// Data menu dan harga. Dipisah dari UI supaya kalau harga berubah,
// kita tidak perlu mengutak-atik kode tampilan.

// Daftar harga makanan (nama menu -> harga)
const Map<String, int> hargaMenu = {
  'Nasi Goreng': 15000,
  'Mie Goreng': 13000,
  'Sate Taichan': 20000,
  'Mie Ayam': 12000,
};

// Daftar harga tambahan (nama tambahan -> harga)
const Map<String, int> hargaTambahan = {
  'Kerupuk': 2000,
  'Telur': 4000,
  'Gorengan': 2000,
  'Sambal': 1000,
};
