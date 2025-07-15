import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vocabpro/models/word_model.dart';

class DictionaryService {
  static const String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<WordModel> getWordDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$word'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return WordModel.fromJson(data[0]);
        } else {
          throw Exception('No definition found for the word');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Word not found');
      } else {
        throw Exception('Failed to load word definition: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Word not found') || e.toString().contains('No definition found')) {
        rethrow;
      }
      throw Exception('Network error: Please check your internet connection');
    }
  }

  Future<List<WordModel>> getRandomWords() async {
    // List of common words for demonstration
    final List<String> sampleWords = [
      'unfortunate',
      'beautiful',
      'magnificent',
      'extraordinary',
      'wonderful',
      'incredible',
      'fantastic',
      'amazing',
      'brilliant',
      'excellent'
    ];

    List<WordModel> words = [];
    
    for (String word in sampleWords.take(5)) {
      try {
        final wordModel = await getWordDefinition(word);
        words.add(wordModel);
      } catch (e) {
        // Skip words that fail to load
        continue;
      }
    }

    return words;
  }
}

