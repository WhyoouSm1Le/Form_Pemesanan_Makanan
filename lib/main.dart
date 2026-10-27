import 'package:aplikasi_pemesanan_makanan/constant/app_colors.dart';
import 'package:aplikasi_pemesanan_makanan/screens/form_pemesanan.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Pemesanan Makanan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
        useMaterial3: true,
      ),
      home: const FormPemesananScreen(),
    );
  }
}