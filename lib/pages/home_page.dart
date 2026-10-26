import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecipeService _service = RecipeService();
  late Future<List<Recipe>> _recipesFuture;
  String _search = '';
  String _goal = 'Semua';

  @override
  void initState() {
    super.initState();
    _recipesFuture = _service.fetchHealthyRecipes();
  }

  void _reload() {
    setState(() {
      _recipesFuture = _service.fetchHealthyRecipes();
    });
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF267447);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HealthyBite 🌿',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Makan Sehat, Hidup Lebih Baik',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Temukan resep sesuai kebutuhanmu.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari resep makanan...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() => _search = value.toLowerCase());
                },
              ),
              const SizedBox(height: 18),

              const Text(
                'Pilih Tujuan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: ['Semua', 'Bulking', 'Diet'].map((goal) {
                  return ChoiceChip(
                    label: Text(goal),
                    selected: _goal == goal,
                    selectedColor: green.withValues(alpha: 0.25),
                    onSelected: (_) {
                      setState(() => _goal = goal);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),

              const Text(
                'Rekomendasi Resep',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Recipe>>(
                future: _recipesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Column(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Text('Resep gagal dimuat.'),
                        TextButton(
                          onPressed: _reload,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    );
                  }

                  final recipes = (snapshot.data ?? [])
                      .where(
                        (recipe) => recipe.name.toLowerCase().contains(_search),
                      )
                      .toList();

                  if (recipes.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Resep tidak ditemukan.')),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(recipe: recipe),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    recipe.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.restaurant, size: 48),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      recipe.category,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
