import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/ui/widgets/app_search_bar.dart';
import 'package:flowrist/core/ui/widgets/filter_button.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/core/ui/widgets/selection_bar.dart';
import 'package:flowrist/core/ui/widgets/selection_shimmer.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTabView extends StatefulWidget {
  const CategoriesTabView({super.key});

  @override
  State<CategoriesTabView> createState() => _CategoriesTabViewState();
}

class _CategoriesTabViewState extends State<CategoriesTabView> {
  @override
  void initState() {
    super.initState();

    context.read<CategoriesCubit>().doEvent(GetCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            final products = state.products.data ?? [];
            return Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.defaultScreenPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: AppSearchBar(
                          onChanged: (value) {
                            // Search will be handled
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        flex: 1,
                        child: FilterButton(
                          onPressed: () {
                            // Filter will be handled
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (state.categories.isLoading)
                  const SelectionShimmer()
                else
                  SelectionBar(
                    items:
                        state.categories.data
                            ?.map((category) => category.name)
                            .toList() ??
                        [],
                    selectedIndex: state.selectedIndex,
                    onItemSelected: (index) {
                      context.read<CategoriesCubit>().doEvent(
                        SelectCategoryEvent(index),
                      );
                    },
                  ),
                SizedBox(height: 25),
                Expanded(
                  child: state.products.isLoading
                      ? const ProductsShimmer()
                      : products.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noProductsFound,
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(
                            AppDimensions.defaultScreenPadding,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.60,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];

                            return ProductCard(
                              title: product.name,
                              price: product.price.toString(),
                              oldPrice: '600',
                              discount: '20',
                              image: product.imageUrl,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
