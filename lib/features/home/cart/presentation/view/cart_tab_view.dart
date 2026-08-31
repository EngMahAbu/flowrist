import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/cart_item_card.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartTabView extends StatefulWidget {
  const CartTabView({super.key});

  @override
  State<CartTabView> createState() => _CartTabViewState();
}

class _CartTabViewState extends State<CartTabView> {
  @override
  void initState() {
    super.initState();

    context.read<CartCubit>().doEvent(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) {
            return previous.cart.data?.totalQuantity !=
                current.cart.data?.totalQuantity;
          },
          builder: (context, state) {
            final cart = state.cart.data;
            final itemCount = cart?.totalQuantity ?? 0;

            return Text(
              '${localization.cart} ($itemCount ${localization.items})',
            );
          },
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.cart.isLoading && state.cart.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.cart.errorMessage != null && state.cart.data == null) {
              return Center(
                child: Text(
                  state.cart.errorMessage!,
                  style: AppStyles.regular14Inter,
                ),
              );
            }

            final cart = state.cart.data;

            if (cart == null || cart.items.isEmpty) {
              return Center(child: Text(localization.yourCartIsEmpty));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 4),
                      Text('Shikh Zaied'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      final isLoading = state.loadingItemIds.contains(
                        item.itemId,
                      );

                      return CartItemCard(
                        item: item,
                        isLoading: isLoading,

                        onDelete: () {
                          context.read<CartCubit>().doEvent(
                            RemoveCartItemEvent(itemId: item.itemId),
                          );
                        },

                        onIncrease: () {
                          if (item.quantity < item.availableStock) {
                            context.read<CartCubit>().doEvent(
                              ChangeCartQuantityEvent(
                                itemId: item.itemId,
                                quantity: item.quantity + 1,
                              ),
                            );
                          }
                        },

                        onDecrease: () {
                          context.read<CartCubit>().doEvent(
                            ChangeCartQuantityEvent(
                              itemId: item.itemId,
                              quantity: item.quantity - 1,
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, _) {
                      return const SizedBox(height: 25);
                    },
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Text(
                        localization.subTotal,
                        style: AppStyles.medium16Roboto,
                      ),
                      const Spacer(),
                      Text(
                        '${localization.egp} ${cart.subtotal}',
                        style: AppStyles.regular14Inter,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        localization.deliveryFee,
                        style: AppStyles.medium16Roboto,
                      ),
                      const Spacer(),
                      Text(
                        '${localization.egp} ${cart.deliveryFee}',
                        style: AppStyles.regular14Inter,
                      ),
                    ],
                  ),

                  const Divider(color: AppColors.white70, thickness: 0.5),

                  // Total
                  Row(
                    children: [
                      Text(localization.total, style: AppStyles.medium18Inter),
                      const Spacer(),
                      Text(
                        '${localization.egp} ${cart.total}',
                        style: AppStyles.medium18Inter,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  AppButton(text: localization.checkout, onPressed: () {}),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
