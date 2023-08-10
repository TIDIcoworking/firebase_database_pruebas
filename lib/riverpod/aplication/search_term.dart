import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTermProvider = StateNotifierProvider<SearchTermNotifier, String>((ref) {
  return SearchTermNotifier();
});

class SearchTermNotifier extends StateNotifier<String> {
  SearchTermNotifier() : super('');

  void setSearchTerm(String value) {
    state = value;
  }
}