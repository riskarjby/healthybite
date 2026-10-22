import 'package:flutter/material.dart';

import '../models/recipe.dart';

class DetailPage extends StatelessWidget {
  final Recipe recipe;

  const DetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF267447);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              recipe.image,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.black12,
                child: const Center(child: Icon(Icons.restaurant, size: 60)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.restaurant_menu),
                    label: Text(recipe.category),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Informasi Gizi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Data kalori, protein, karbohidrat, lemak, '
                    'dan serat belum tersedia untuk resep ini.',
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Bahan-Bahan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: green,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ingredient)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Cara Memasak',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recipe.instructions.trim().isEmpty
                        ? 'Instruksi memasak belum tersedia.'
                        : recipe.instructions,
                    style: const TextStyle(height: 1.6),
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
