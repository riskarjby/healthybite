import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const HealthyBiteApp());
}

const Color green = Color(0xFF2E7D32);
const Color darkGreen = Color(0xFF174B2A);
const Color bgColor = Color(0xFFF6F8F3);

// ================= APLIKASI =================

class HealthyBiteApp extends StatelessWidget {
  const HealthyBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthyBite',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: bgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: bgColor,
          foregroundColor: darkGreen,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ================= MODEL RESEP =================

class Recipe {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.area,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = (json['strIngredient$i'] ?? '').toString().trim();

      final measure = (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        ingredients.add(
          measure.isNotEmpty ? '$measure $ingredient' : ingredient,
        );
      }
    }

    return Recipe(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Resep tanpa nama',
      image: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? 'Makanan',
      area: json['strArea']?.toString() ?? 'Internasional',
      instructions:
          json['strInstructions']?.toString() ?? 'Instruksi belum tersedia.',
      ingredients: ingredients,
    );
  }
}

// ================= API RESEP =================

class RecipeService {
  static Future<List<Recipe>> fetchRecipes(String goal) async {
    final List<String> queries;

    if (goal == 'Bulking') {
      queries = ['chicken', 'beef', 'pasta'];
    } else if (goal == 'Diet') {
      queries = ['salad', 'fish', 'vegetable'];
    } else {
      queries = ['chicken', 'salad', 'fish'];
    }

    final Map<String, Recipe> uniqueRecipes = {};

    for (final query in queries) {
      final uri = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
      );

      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil resep dari server.');
      }

      final data = jsonDecode(response.body);
      final meals = data['meals'];

      if (meals != null && meals is List) {
        for (final meal in meals) {
          final recipe = Recipe.fromJson(Map<String, dynamic>.from(meal));

          uniqueRecipes[recipe.id] = recipe;
        }
      }
    }

    final results = uniqueRecipes.values.toList();

    if (results.isEmpty) {
      throw Exception('Resep tidak ditemukan.');
    }

    return results;
  }
}

// ================= HALAMAN UTAMA =================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedGoal = 'Semua';
  String searchQuery = '';

  late Future<List<Recipe>> recipesFuture;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recipesFuture = RecipeService.fetchRecipes(selectedGoal);
  }

  void changeGoal(String goal) {
    setState(() {
      selectedGoal = goal;
      searchQuery = '';
      searchController.clear();
      recipesFuture = RecipeService.fetchRecipes(goal);
    });
  }

  void retry() {
    setState(() {
      recipesFuture = RecipeService.fetchRecipes(selectedGoal);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final future = RecipeService.fetchRecipes(selectedGoal);

            setState(() {
              recipesFuture = future;
            });

            await future;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo dan nama aplikasi
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HealthyBite',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                              Text(
                                'Makan sehat, hidup lebih baik',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Pilih tujuan makanmu',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filter kategori
                      Wrap(
                        spacing: 8,
                        children: ['Semua', 'Bulking', 'Diet'].map((goal) {
                          return ChoiceChip(
                            label: Text(goal),
                            selected: selectedGoal == goal,
                            selectedColor: const Color(0xFFC8E6C9),
                            onSelected: (_) => changeGoal(goal),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Pencarian resep
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari nama resep...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        selectedGoal == 'Bulking'
                            ? 'Resep untuk Bulking'
                            : selectedGoal == 'Diet'
                            ? 'Resep untuk Diet Seimbang'
                            : 'Jelajahi Resep',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        selectedGoal == 'Bulking'
                            ? 'Pilihan resep dari pencarian ayam, daging, dan pasta.'
                            : selectedGoal == 'Diet'
                            ? 'Pilihan resep dari pencarian salad, ikan, dan sayuran.'
                            : 'Temukan inspirasi makanan sehari-hari.',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),

              // Mengambil dan menampilkan data API
              FutureBuilder<List<Recipe>>(
                future: recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 50,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Resep gagal dimuat',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Periksa koneksi internet, lalu coba lagi.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              FilledButton(
                                onPressed: retry,
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final recipes = (snapshot.data ?? []).where((recipe) {
                    return recipe.name.toLowerCase().contains(searchQuery);
                  }).toList();

                  if (recipes.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: Text('Resep tidak ditemukan.')),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return RecipeCard(
                          recipe: recipes[index],
                          goal: selectedGoal,
                        );
                      }, childCount: recipes.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= KARTU RESEP =================

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final String goal;

  const RecipeCard({super.key, required this.recipe, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(recipe: recipe, goal: goal),
            ),
          );
        },
        child: SizedBox(
          height: 132,
          child: Row(
            children: [
              SizedBox(
                width: 125,
                height: double.infinity,
                child: Image.network(
                  recipe.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return const ColoredBox(
                      color: Color(0xFFE0E0E0),
                      child: Icon(Icons.restaurant, size: 40),
                    );
                  },
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${recipe.category} • ${recipe.area}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),

                      const Spacer(),

                      const Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: green),
                          SizedBox(width: 5),
                          Text(
                            'Lihat detail resep',
                            style: TextStyle(
                              color: green,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.chevron_right, color: green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= DETAIL RESEP =================

class DetailPage extends StatelessWidget {
  final Recipe recipe;
  final String goal;

  const DetailPage({super.key, required this.recipe, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Resep')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Foto resep
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              recipe.image,
              height: 230,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const SizedBox(
                  height: 180,
                  child: Icon(Icons.restaurant, size: 60),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Nama resep
          Text(
            recipe.name,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            '${recipe.category} • ${recipe.area}',
            style: const TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 22),

          // Bahan-bahan
          const Text(
            'Bahan-bahan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (recipe.ingredients.isEmpty)
            const Text('Bahan-bahan belum tersedia.')
          else
            ...recipe.ingredients.map((ingredient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ingredient,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 24),

          // Cara memasak
          const Text(
            'Cara Memasak',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            recipe.instructions.replaceAll('\r\n', '\n').replaceAll('\r', '\n'),
            style: const TextStyle(fontSize: 15, height: 1.7),
          ),

          const SizedBox(height: 24),

          // Informasi sumber data
          const Divider(),

          const Text(
            'Sumber resep: TheMealDB',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
