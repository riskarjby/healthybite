import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe.dart';

class RecipeService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Recipe>> fetchHealthyRecipes() async {
    final url = Uri.parse('$baseUrl/search.php?s=chicken');

    final response = await http.get(url).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data resep');
    }

    final Map<String, dynamic> jsonData =
        jsonDecode(response.body) as Map<String, dynamic>;

    final List<dynamic> meals = jsonData['meals'] as List<dynamic>? ?? [];

    return meals
        .map((meal) => Recipe.fromJson(meal as Map<String, dynamic>))
        .toList();
  }
}
