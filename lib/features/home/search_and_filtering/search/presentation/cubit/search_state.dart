import 'package:flutter/foundation.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';

class SearchState {
  final String query;
  final BaseState<List<ProductEntity>> results;

  const SearchState({required this.query, required this.results});

  factory SearchState.initial() {
    return SearchState(
      query: '',
      results: BaseState<List<ProductEntity>>(
        isLoading: false,
        errorMessage: null,
        data: null,
      ),
    );
  }

  SearchState copyWith({
    String? query,
    BaseState<List<ProductEntity>>? results,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchState &&
        other.query == query &&
        other.results.isLoading == results.isLoading &&
        other.results.errorMessage == results.errorMessage &&
        listEquals(other.results.data, results.data);
  }

  @override
  int get hashCode =>
      Object.hash(query, results.isLoading, results.errorMessage, results.data);

  @override
  String toString() =>
      'SearchState(query: $query, isLoading: ${results.isLoading}, errorMessage: ${results.errorMessage}, data: ${results.data})';
}
