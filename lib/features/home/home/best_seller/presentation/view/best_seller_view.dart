import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';

class BestSellerView extends StatelessWidget {
  BestSellerView({super.key});

  final List<Map<String, String>> products = [
    {
      'title': 'Red Rose',
      'price': '600',
      'oldPrice': '800',
      'discount': '20%',
      'image':
          'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1200&webp=1',
    },
    {
      'title': 'White Lily',
      'price': '450',
      'oldPrice': '600',
      'discount': '25%',
      'image':
          'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1200&webp=1',
    },
    {
      'title': 'Yellow Tulip',
      'price': '350',
      'oldPrice': '500',
      'discount': '30%',
      'image':
          'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1200&webp=1',
    },
    {
      'title': 'Pink Orchid',
      'price': '750',
      'oldPrice': '950',
      'discount': '21%',
      'image':
          'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1200&webp=1',
    },
    {
      'title': 'Blue Hydrangea',
      'price': '550',
      'oldPrice': '700',
      'discount': '22%',
      'image':
          'https://c02.purpledshub.com/uploads/sites/40/2023/08/JI230816Cosmos220-6d9254f-edited-scaled.jpg?w=1200&webp=1',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsetsGeometry.directional(
            start: AppDimensions.defaultScreenPadding,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: const Text('Best Seller'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 55,
              bottom: 8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bloom with our exquisite best sellers',
                style: AppStyles.regular13W500,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
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
              title: product['title']!,
              price: product['price']!,
              oldPrice: product['oldPrice']!,
              discount: product['discount']!,
              image: product['image']!,
            );
          },
        ),
      ),
    );
  }
}

