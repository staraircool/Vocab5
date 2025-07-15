class WordModel {
  final String word;
  final String phonetic;
  final String definition;
  final List<String> synonyms;
  final String partOfSpeech;
  final String audioUrl;

  WordModel({
    required this.word,
    required this.phonetic,
    required this.definition,
    required this.synonyms,
    required this.partOfSpeech,
    required this.audioUrl,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    // Extract phonetic
    String phonetic = '';
    if (json['phonetics'] != null && json['phonetics'].isNotEmpty) {
      for (var phoneticData in json['phonetics']) {
        if (phoneticData['text'] != null && phoneticData['text'].isNotEmpty) {
          phonetic = phoneticData['text'];
          break;
        }
      }
    }

    // Extract definition and synonyms
    String definition = '';
    List<String> synonyms = [];
    String partOfSpeech = '';
    String audioUrl = '';

    if (json['meanings'] != null && json['meanings'].isNotEmpty) {
      var meaning = json['meanings'][0];
      partOfSpeech = meaning['partOfSpeech'] ?? '';
      
      if (meaning['definitions'] != null && meaning['definitions'].isNotEmpty) {
        var def = meaning['definitions'][0];
        definition = def['definition'] ?? '';
        
        if (def['synonyms'] != null) {
          synonyms = List<String>.from(def['synonyms']);
        }
      }
      
      if (meaning['synonyms'] != null) {
        synonyms.addAll(List<String>.from(meaning['synonyms']));
      }
    }

    // Extract audio URL
    if (json['phonetics'] != null && json['phonetics'].isNotEmpty) {
      for (var phoneticData in json['phonetics']) {
        if (phoneticData['audio'] != null && phoneticData['audio'].isNotEmpty) {
          audioUrl = phoneticData['audio'];
          break;
        }
      }
    }

    return WordModel(
      word: json['word'] ?? '',
      phonetic: phonetic,
      definition: definition,
      synonyms: synonyms.take(5).toList(), // Limit to 5 synonyms
      partOfSpeech: partOfSpeech,
      audioUrl: audioUrl,
    );
  }
}

