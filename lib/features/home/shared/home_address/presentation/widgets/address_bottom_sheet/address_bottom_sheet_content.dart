import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/cubit/home_address_cubit/home_address_cubit.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/cubit/home_address_cubit/home_address_state.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/cubit/home_address_cubit/home_address_event.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/widgets/address_bottom_sheet/address_item.dart';
import 'package:flowrist/features/home/shared/home_address/presentation/widgets/address_bottom_sheet/empty_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBottomSheetContent extends StatefulWidget {
  final List<AddressEntity> addresses;
  final String? selectedAddressId;

  const AddressBottomSheetContent({
    super.key,
    required this.addresses,
    required this.selectedAddressId,
  });

  @override
  State<AddressBottomSheetContent> createState() =>
      _AddressBottomSheetContentState();
}

class _AddressBottomSheetContentState extends State<AddressBottomSheetContent> {
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();

    _selectedAddressId = widget.selectedAddressId;
  }

  AddressEntity? get selectedAddress {
    for (final address in widget.addresses) {
      if (address.id == _selectedAddressId) {
        return address;
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // Only temporary selection.
  // Does NOT update AddressCubit.
  // ------------------------------------------------------------

  void _selectAddress(AddressEntity address) {
    setState(() {
      _selectedAddressId = address.id;
    });
  }

  // ------------------------------------------------------------
  // Set selected address as default
  // ------------------------------------------------------------

  void _setAsDefault() {
    final address = selectedAddress;

    if (address == null) {
      return;
    }

    context.read<HomeAddressCubit>().doEvent(SetDefaultAddress(address.id));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final addresses = widget.addresses;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                localizations.selectAddress,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: addresses.isEmpty
                    ? const EmptyAddressView()
                    : ListView.separated(
                        itemCount: addresses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final address = addresses[index];

                          return AddressItem(
                            address: address,
                            isSelected: address.id == _selectedAddressId,
                            onTap: () {
                              _selectAddress(address);
                            },
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),

              if (addresses.isNotEmpty)
                BlocConsumer<HomeAddressCubit, HomeAddressState>(
                  listener: (context, state) {
                    final defaultState = state.setDefaultAddressState;

                    // PATCH succeeded
                    if (!defaultState.isLoading &&
                        defaultState.errorMessage == null &&
                        defaultState.data != null) {
                      Navigator.pop(context);
                    }

                    // PATCH failed
                    if (!defaultState.isLoading &&
                        defaultState.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(defaultState.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state.setDefaultAddressState.isLoading;

                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            onPressed: selectedAddress == null || isLoading
                                ? null
                                : _setAsDefault,
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(localizations.setAsDefault),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // TODO:
                              // Add new address
                            },
                            child: const Icon(Icons.add, size: 25),
                          ),
                        ),
                      ],
                    );
                  },
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO:
                      // Add new address
                    },
                    icon: const Icon(Icons.add, size: 25),
                    label: Text(localizations.addNewaddress),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
