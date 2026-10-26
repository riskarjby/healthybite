class Recipe {
  final int id;
  final String name;
  final String image;
  final String category;
  final String instructions;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final amount = measure?.toString().trim() ?? '';

        ingredients.add(
          amount.isEmpty
              ? ingredient.toString()
              : '$amount ${ingredient.toString()}',
        );
      }
    }

    return Recipe(
      id: int.tryParse(json['idMeal']?.toString() ?? '') ?? 0,
      name: json['strMeal']?.toString() ?? 'Resep Tanpa Nama',
      image: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? 'Lainnya',
      instructions:
          json['strInstructions']?.toString() ?? 'Belum ada instruksi.',
      ingredients: ingredients,
    );
  }
}
