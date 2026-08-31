import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_search_bar.dart';
import 'package:flowrist/core/ui/widgets/filter_button.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/core/ui/widgets/selection_bar.dart';
import 'package:flowrist/core/ui/widgets/selection_shimmer.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_state.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesTabView extends StatelessWidget {
  const CategoriesTabView({super.key});

  void _openFilter(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final selected = await FilterBottomSheet.show(
      context,
      currentSelection: cubit.state.selectedSort,
    );
    if (selected != cubit.state.selectedSort) {
      cubit.doEvent(ApplySortEvent(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final isFilterActive = state.selectedSort != null;
        final products = state.products.data ?? [];
        final categories = state.categories.data ?? [];

        return Scaffold(
          backgroundColor: AppColors.whiteBase,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.purpleBase,
            foregroundColor: AppColors.white,
            elevation: 4,
            shape: const StadiumBorder(),
            onPressed: () => _openFilter(context),
            icon: const Icon(Icons.tune, size: 20),
            label: Text(
              AppLocalizations.of(context)!.filter,
              style: AppStyles.medium16Inter,
            ),
          ),
          body: SafeArea(
            child: Column(
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
                          readOnly: true,
                          onTap: () {
                            context.push(AppRoutes.search);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: FilterButton(
                          isSelected: isFilterActive,
                          onPressed: () => _openFilter(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (state.categories.isLoading)
                  const SelectionShimmer()
                else
                  SelectionBar(
                    items: categories.map((category) => category.name).toList(),
                    selectedIndex: state.selectedIndex,
                    onItemSelected: (index) {
                      context.read<CategoriesCubit>().doEvent(
                        SelectCategoryEvent(index),
                      );
                    },
                  ),
                const SizedBox(height: 25),
                Expanded(
                  child: state.products.isLoading
                      ? const ProductsShimmer()
                      : products.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noProductsFound,
                            style: AppStyles.regular14Inter,
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimensions.defaultScreenPadding,
                            AppDimensions.defaultScreenPadding,
                            AppDimensions.defaultScreenPadding,
                            80,
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
                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRoutes.productDetailsPath(product.id),
                                );
                              },
                              child: ProductCard(
                                productId: product.id,
                                title: product.name,
                                price: product.price.toString(),
                                oldPrice:
                                    product.discountPrice?.toString() ?? '',
                                discount: product.discountPercentage != null
                                    ? '${product.discountPercentage!.toInt()}%'
                                    : '',
                                image: product.imageUrl,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
