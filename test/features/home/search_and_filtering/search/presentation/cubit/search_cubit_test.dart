import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/product_entity.dart';
import 'package:flowrist/features/home/search_and_filtering/search/domain/use_cases/search_products_use_case.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_cubit.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_events.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_cubit_test.mocks.dart';

@GenerateMocks([SearchProductsUseCase])
void main() {
  late MockSearchProductsUseCase mockUseCase;

  setUp(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessResponse<List<ProductEntity>>([]),
    );
    mockUseCase = MockSearchProductsUseCase();
  });

  final tProducts = [
    const ProductEntity(
      id: '1',
      name: 'Red Rose',
      price: 100.0,
      discountPercentage: null,
      discountPrice: null,
      inStock: true,
      categoryId: 'cat_1',
      categoryName: 'Flowers',
      imageUrl: 'https://example.com/rose.png',
    ),
  ];

  test('initial state should have empty query and default empty BaseState', () {
    final cubit = SearchCubit(mockUseCase);
    expect(cubit.state, equals(SearchState.initial()));
    cubit.close();
  });

  group('SearchQueryChangedEvent', () {
    blocTest<SearchCubit, SearchState>(
      'emits updated query with empty results immediately when query is whitespace or empty',
      build: () => SearchCubit(mockUseCase),
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('   ')),
      expect: () => [
        SearchState(
          query: '   ',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
      ],
      verify: (_) {
        verifyZeroInteractions(mockUseCase);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits loading and success states after 500ms debounce delay when query is valid',
      build: () {
        when(mockUseCase(query: 'Rose', page: 1, pageSize: 20)).thenAnswer(
          (_) async => SuccessResponse<List<ProductEntity>>(tProducts),
        );
        return SearchCubit(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('Rose')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: tProducts,
          ),
        ),
      ],
      verify: (_) {
        verify(mockUseCase(query: 'Rose', page: 1, pageSize: 20)).called(1);
      },
    );

    blocTest<SearchCubit, SearchState>(
      'emits loading and error states after debounce delay when use case returns ErrorResponse',
      build: () {
        when(mockUseCase(query: 'Rose', page: 1, pageSize: 20)).thenAnswer(
          (_) async => ErrorResponse<List<ProductEntity>>('Network Failure'),
        );
        return SearchCubit(mockUseCase);
      },
      act: (cubit) => cubit.doEvent(const SearchQueryChangedEvent('Rose')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: true,
            errorMessage: null,
            data: null,
          ),
        ),
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: 'Network Failure',
            data: null,
          ),
        ),
      ],
    );
  });

  group('ClearSearchEvent', () {
    blocTest<SearchCubit, SearchState>(
      'resets cubit state to SearchState.initial()',
      build: () => SearchCubit(mockUseCase),
      act: (cubit) {
        cubit.doEvent(const SearchQueryChangedEvent('Rose'));
        cubit.doEvent(const ClearSearchEvent());
      },
      expect: () => [
        SearchState(
          query: 'Rose',
          results: BaseState<List<ProductEntity>>(
            isLoading: false,
            errorMessage: null,
            data: null,
          ),
        ),
        SearchState.initial(),
      ],
    );
  });
}
