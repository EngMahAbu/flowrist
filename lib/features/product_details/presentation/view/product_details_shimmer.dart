import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _box(
                    width: double.infinity,
                    height: 28,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _box(width: 100, height: 24),
                      const SizedBox(width: 12),
                      _box(width: 70, height: 20),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _box(
                    width: 120,
                    height: 22,
                  ),
                  const SizedBox(height: 12),
                  _box(
                    width: double.infinity,
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  _box(
                    width: 100,
                    height: 22,
                  ),
                  const SizedBox(height: 12),
                  _box(
                    width: double.infinity,
                    height: 20,
                  ),
                  const SizedBox(height: 8),
                  _box(
                    width: 180,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _box({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}