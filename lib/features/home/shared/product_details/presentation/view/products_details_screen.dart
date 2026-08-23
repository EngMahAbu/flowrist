import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view/product_details_shimmer.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_event/product_details_event.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_view_model/product_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductDetailsViewModel>()
            ..add(GetProductDetailsEvent(productId)),
      child: _ProductDetailsView(productId: productId),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final String productId;

  const _ProductDetailsView({required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ProductDetailsViewModel,
      BaseState<ProductDetailsRequestDto>
    >(
      builder: (context, state) {
        // -----------------------------
        // Loading
        // -----------------------------
        if (state.isLoading) {
          return const Scaffold(body: ProductDetailsShimmer());
        }

        // -----------------------------
        // Error
        // -----------------------------
        if (state.errorMessage != null) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 12),

                    Text(state.errorMessage!, textAlign: TextAlign.center),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailsViewModel>().add(
                          GetProductDetailsEvent(productId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // -----------------------------
        // Success
        // -----------------------------
        final product = state.data;

        if (product == null) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Product not found')),
          );
        }

        return _ProductDetailsBody(product: product);
      },
    );
  }
}

class _ProductDetailsBody extends StatefulWidget {
  final ProductDetailsRequestDto product;

  const _ProductDetailsBody({required this.product});

  @override
  State<_ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<_ProductDetailsBody> {
  static const double _expandedHeight = 460;

  final PageController _pageController = PageController();

  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final images = product.images;

    return Scaffold(
      backgroundColor: Colors.white,

      // ==========================================
      // ADD TO CART
      // ==========================================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: product.inStock
                  ? () async {
                      final canContinue = await checkGuestMode(context);
                      if (!canContinue || !context.mounted) return;

                      if (context.canPop()) {
                        context.pop();
                      }

                      context.go(AppRoutes.cartTab);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE1567),
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: CustomScrollView(
        slivers: [
          // ========================================
          // PRODUCT IMAGE
          // ========================================
          SliverAppBar(
            expandedHeight: _expandedHeight,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF9F9F9),

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;

                final delta = top - kToolbarHeight;

                final totalExpand = _expandedHeight - kToolbarHeight;

                final expandRatio = (delta / totalExpand).clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,

                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ==================================
                      // NO IMAGES
                      // ==================================
                      if (images.isEmpty)
                        Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      // ==================================
                      // IMAGES
                      // ==================================
                      else
                        Transform.scale(
                          scale: 0.85 + (0.15 * expandRatio),
                          child: Opacity(
                            opacity: expandRatio,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, _, _) {
                                    return Container(
                                      color: const Color(0xFFF5F5F5),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                      // ==================================
                      // IMAGE INDICATORS
                      // ==================================
                      if (images.length > 1 && expandRatio > 0.2)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              final isSelected = _currentImageIndex == index;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: isSelected ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected
                                      ? const Color(0xFFCE1567)
                                      : Colors.grey.shade400.withValues(
                                          alpha: 0.7,
                                        ),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ==========================================
          // PRODUCT INFORMATION
          // ==========================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================
                  // PRICE + STOCK
                  // ==================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PRICE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'EGP ${(product.discountedPrice ?? product.price).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),

                              if (product.discountedPrice != null &&
                                  product.discountedPrice! < product.price) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'EGP ${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'All prices include tax',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      // STOCK
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111111),
                            ),
                          ),

                          Text(
                            product.inStock ? 'In stock' : 'Out of stock',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: product.inStock
                                  ? Colors.grey.shade700
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ==================================
                  // PRODUCT NAME
                  // ==================================
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================
                  // DESCRIPTION
                  // ==================================
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No description available for this product.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  // ==================================
                  // AVAILABLE STOCK
                  // ==================================
                  if (product.availableStock > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Available: ${product.availableStock} items',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  // ==================================
                  // INCLUDES
                  // ==================================
                  if (product.includes.isNotEmpty) ...[
                    const SizedBox(height: 24),

                    const Text(
                      'Bouquet include',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ...product.includes.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }),
                  ],

                  // Bottom spacing for the
                  // Add to Cart button.
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
