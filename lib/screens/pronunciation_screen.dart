import 'package:flutter/material.dart';
import 'package:vocabpro/services/dictionary_service.dart';
import 'package:vocabpro/models/word_model.dart';

class PronunciationScreen extends StatefulWidget {
  const PronunciationScreen({super.key});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  final DictionaryService _dictionaryService = DictionaryService();
  WordModel? _currentWord;
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
  }

  Future<void> _loadRandomWord() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load a sample word - "unfortunate" as shown in the design
      final word = await _dictionaryService.getWordDefinition('unfortunate');
      setState(() {
        _currentWord = word;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading word: $e')),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadRandomWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pronunciation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF8B5CF6),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF8B5CF6),
                  backgroundColor: Colors.transparent,
                ),
              )
            : _currentWord == null
                ? const Center(
                    child: Text(
                      'No word loaded',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildWordCard(),
                          const SizedBox(height: 30),
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildWordCard() {
    if (_currentWord == null) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentWord!.phonetic.isNotEmpty)
            Text(
              _currentWord!.phonetic,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            _currentWord!.word,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          if (_currentWord!.definition.isNotEmpty)
            Text(
              _currentWord!.definition,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 20),
          if (_currentWord!.synonyms.isNotEmpty) ...[
            const Text(
              'Synonyms:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _currentWord!.synonyms
                  .take(3)
                  .map((synonym) => _buildSynonymTag(synonym))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSynonymTag(String synonym) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        synonym,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          Icons.volume_up,
          () {
            // TODO: Implement text-to-speech
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Audio playback not implemented')),
            );
          },
        ),
        _buildActionButton(
          Icons.mic,
          () {
            // TODO: Implement speech recognition
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Speech recognition not implemented')),
            );
          },
        ),
        _buildActionButton(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}

