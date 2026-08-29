import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/cart_item_card.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
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
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final cart = state.cart.data;

            return Text('Cart (${cart?.totalQuantity ?? 0} items)');
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
              return const Center(child: Text('Your cart is empty'));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 4),
                      BlocBuilder<AddressesViewModel, AddressesState>(
                        builder: (context, state) {
                          final selectedAddress = state.selectedAddress;
                          return Text(
                            '${localizations.deliverTo} '
                            '${selectedAddress?.area}-${selectedAddress?.addressLine}',
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      final isLoading = state.loadingItemId == item.itemId;

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
                      Text('Sub Total', style: AppStyles.medium16Roboto),
                      const Spacer(),
                      Text(
                        'EGP ${cart.subtotal}',
                        style: AppStyles.regular14Inter,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Delivery Fee', style: AppStyles.medium16Roboto),
                      const Spacer(),
                      Text(
                        'EGP ${cart.deliveryFee}',
                        style: AppStyles.regular14Inter,
                      ),
                    ],
                  ),

                  const Divider(color: AppColors.white70, thickness: 0.5),

                  // Total
                  Row(
                    children: [
                      Text('Total', style: AppStyles.medium18Inter),
                      const Spacer(),
                      Text('EGP ${cart.total}', style: AppStyles.medium18Inter),
                    ],
                  ),

                  const SizedBox(height: 40),

                  AppButton(text: 'Checkout', onPressed: () {}),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
