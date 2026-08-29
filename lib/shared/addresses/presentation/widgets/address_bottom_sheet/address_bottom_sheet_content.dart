import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/features/addresses/presentation/view/add_address_view.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/address_item.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/empty_address_view.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../view_model/addresses_state.dart';

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
  late String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _selectedAddressId = widget.selectedAddressId;
  }

  AddressEntity? get _selectedAddress {
    for (final address in widget.addresses) {
      if (address.id == _selectedAddressId) {
        return address;
      }
    }

    return null;
  }

  void _selectAddress(AddressEntity address) {
    if (_selectedAddressId == address.id) {
      return;
    }

    setState(() {
      _selectedAddressId = address.id;
    });
  }

  void _setAsDefault(BuildContext context) {
    final address = _selectedAddress;

    if (address == null) {
      return;
    }

    context.read<AddressesViewModel>().doEvent(SetDefaultAddress(address.id));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHandle(),

              const SizedBox(height: 20),

              Text(
                localizations.selectAddress,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(child: _buildAddressList()),

              const SizedBox(height: 16),

              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    if (widget.addresses.isEmpty) {
      return const EmptyAddressView();
    }

    return ListView.separated(
      itemCount: widget.addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = widget.addresses[index];

        return AddressItem(
          address: address,
          isSelected: address.id == _selectedAddressId,
          onTap: () => _selectAddress(address),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    if (widget.addresses.isEmpty) {
      return _buildAddAddressButton();
    }

    return BlocConsumer<AddressesViewModel, AddressesState>(
      listenWhen: (previous, current) {
        final previousState = previous.setDefaultAddressState;
        final currentState = current.setDefaultAddressState;

        return previousState.isLoading != currentState.isLoading ||
            previousState.errorMessage != currentState.errorMessage ||
            previousState.data != currentState.data;
      },
      listener: (context, state) {
        final defaultState = state.setDefaultAddressState;

        if (defaultState.isLoading) {
          return;
        }

        if (defaultState.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(defaultState.errorMessage!)));

          return;
        }

        if (defaultState.data != null) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.setDefaultAddressState.isLoading;

        return _buildAddressActions(context: context, isLoading: isLoading);
      },
    );
  }

  Widget _buildAddressActions({
    required BuildContext context,
    required bool isLoading,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: _selectedAddress == null || isLoading
                ? null
                : () => _setAsDefault(context),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppLocalizations.of(context)!.setAsDefault),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(flex: 1, child: _buildAddIconButton()),
      ],
    );
  }

  Widget _buildAddIconButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        context.go(AppRoutes.addAddress);
      },
      child: const Icon(Icons.add, size: 25),
    );
  }

  Widget _buildAddAddressButton() {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Add new address
        },
        icon: const Icon(Icons.add, size: 25),
        label: Text(localizations.addNewaddress),
      ),
    );
  }
}
