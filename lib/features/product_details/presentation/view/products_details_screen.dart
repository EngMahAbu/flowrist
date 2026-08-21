import 'package:flowrist/features/product_details/presentation/view/product_details_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';

import '../../../../config/base_state/base_state.dart';
import '../../data/models/product_details_request_dto.dart';
import '../view_model/product_details_event/product_details_event.dart';
import '../view_model/product_details_view_model/product_details_view_model.dart';
import '../widgets/error_view.dart';
import '../widgets/image_indecator.dart';
import '../widgets/price_selection.dart';
import '../widgets/section_title.dart';
import '../widgets/stock_info.dart';
import '../widgets/stock_status.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailsViewModel>()
        ..add(
          GetProductDetailsEvent(productId),
        ),
      child: const _ProductDetailsView(),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  const _ProductDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsViewModel,
        BaseState<ProductDetailsRequestDto>>(
      builder: (context, state) {
        if (state.isLoading) {
          return const ProductDetailsShimmer();
        }

        if (state.errorMessage != null) {
          return ErrorView(
            message: state.errorMessage!,
            onRetry: () {
              final productId = context
                  .read<ProductDetailsViewModel>()
                  .state
                  .data
                  ?.id;

              if (productId != null) {
                context.read<ProductDetailsViewModel>().add(
                  GetProductDetailsEvent(productId),
                );
              }
            },
          );
        }

        final product = state.data;

        if (product == null) {
          return const SizedBox.shrink();
        }

        return _ProductDetailsContent(product: product);
      },
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final ProductDetailsRequestDto product;

  const _ProductDetailsContent({
    required this.product,
  });

  @override
  State<_ProductDetailsContent> createState() =>
      _ProductDetailsContentState();
}

class _ProductDetailsContentState
    extends State<_ProductDetailsContent> {
  final PageController _pageController = PageController();

  int _currentImage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: product.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        product.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ImageIndicator(
                          currentIndex: _currentImage,
                          count: product.images.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    product.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  PriceSection(product: product),

                  const SizedBox(height: 16),

                  StockStatus(
                    product: product,
                    localizations: localizations,
                  ),

                  const SizedBox(height: 24),

                  SectionTitle(
                    title: localizations.productDescription,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 24),

                  SectionTitle(
                    title: localizations.productIncludes,
                  ),

                  const SizedBox(height: 8),

                  ...product.includes.map(
                        (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  StockInformation(
                    product: product,
                    localizations: localizations,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}