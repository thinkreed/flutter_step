import 'package:flutter/material.dart';
import 'RandomWords.dart';
import 'package:english_words/english_words.dart';

class RandomWordState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    final WordPair wordPair = new WordPair.random();
    return new Text(wordPair.asPascalCase);
  }
}
