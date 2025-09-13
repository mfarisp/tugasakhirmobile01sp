import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama Produk")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Harga")),
            const SizedBox(height: 10),
            imageFile != null
                ? Image.file(imageFile!, height: 100)
                : const Text("Belum ada gambar"),
            ElevatedButton(onPressed: pickImage, child: const Text("Pilih Gambar")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final url = await StorageService.uploadImage(imageFile!);
                await FirestoreService.addProduct(nameController.text, priceController.text, url);
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
