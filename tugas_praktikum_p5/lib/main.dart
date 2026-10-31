import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Katalog Produk & Smartphone',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// Model Data Produk
class ProductModel {
  final String name;
  final String imageUrl;
  final String description;
  final String price;
  final Color themeColor;

  ProductModel({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.themeColor,
  });
}

// 1. Halaman Utama (HomePage)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftar produk awal + banyak pilihan merek HP tambahan
    final List<ProductModel> products = [
      // Produk awal
      ProductModel(
        name: 'Laptop Pro',
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=600&auto=format&fit=crop',
        description: 'Laptop performa tinggi dengan prosesor kencang untuk kebutuhan coding, desain grafis, dan multitasking berat.',
        price: 'Rp 12.499.000',
        themeColor: Colors.blue,
      ),
      ProductModel(
        name: 'Smartphone X',
        imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=600&auto=format&fit=crop',
        description: 'Smartphone gaming & multimedia dengan layar AMOLED 120Hz yang sangat mulus serta kamera jernih beresolusi tinggi.',
        price: 'Rp 3.799.000',
        themeColor: Colors.teal,
      ),
      ProductModel(
        name: 'Headphone Air',
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600&auto=format&fit=crop',
        description: 'Headphone nirkabel dengan teknologi active noise cancellation dan kualitas audio bass yang menggelegar.',
        price: 'Rp 1.299.000',
        themeColor: Colors.deepOrange,
      ),
      // Tambahan berbagai merek HP
      ProductModel(
        name: 'Infinix Note 50 X',
        imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=600&auto=format&fit=crop',
        description: 'Smartphone gaming andalan dengan performa stabil, layar AMOLED 120Hz yang mulus, serta sistem pendingin canggih.',
        price: 'Rp 2.499.000',
        themeColor: Colors.green,
      ),
      ProductModel(
        name: 'Xiaomi Redmi Note 13 Pro',
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600&auto=format&fit=crop',
        description: 'Hadir dengan kamera utama 200MP beresolusi tinggi dilengkapi OIS, pengisian daya cepat 67W Turbo Charge.',
        price: 'Rp 3.799.000',
        themeColor: Colors.amber.shade800,
      ),
      ProductModel(
        name: 'Samsung Galaxy A55 5G',
        imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=600&auto=format&fit=crop',
        description: 'Ponsel kelas menengah premium dengan bodi belakang kaca, sertifikasi ketahanan air IP67, serta Samsung Knox Vault.',
        price: 'Rp 5.999.000',
        themeColor: Colors.indigo,
      ),
      ProductModel(
        name: 'iPhone 15',
        imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=600&auto=format&fit=crop',
        description: 'Dilengkapi fitur interaktif Dynamic Island, kamera utama 48MP dengan telefoto 2x, port USB-C, dan chip A16 Bionic.',
        price: 'Rp 14.249.000',
        themeColor: Colors.blueGrey,
      ),
      ProductModel(
        name: 'iQOO Z9 5G',
        imageUrl: 'https://images.unsplash.com/photo-1565849904461-04a58ad377e0?q=80&w=600&auto=format&fit=crop',
        description: 'Monster performa dengan Snapdragon 7 Gen 3, baterai jumbo super awet 6000mAh dalam bodi yang tipis.',
        price: 'Rp 4.199.000',
        themeColor: Colors.purple,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk & Smartphone'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                product.price,
                style: TextStyle(color: product.themeColor, fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 2. Halaman Detail (DetailPage)
class DetailPage extends StatelessWidget {
  final ProductModel product;

  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: product.themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk Berbeda-beda
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ini adalah halaman detail untuk:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: product.themeColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 30),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}