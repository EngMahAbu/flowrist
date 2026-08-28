import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/location_services/location_services.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/default_address_entity.dart';
import 'package:flowrist/features/home/shared/home_address/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flowrist/features/home/shared/home_address/domain/use_cases/set_default_address_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'address_state.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  final GetAllUserAddressesUseCase _getAllUserAddressesUseCase;
  final SetDefaultAddressUseCase _setDefaultAddressUseCase;
  final LocationService _locationService;

  AddressCubit(
    this._getAllUserAddressesUseCase,
    this._locationService,
    this._setDefaultAddressUseCase,
  ) : super(
          AddressState(
            addressesState: BaseState.initial(),
            setDefaultAddressState: BaseState.initial(),
          ),
        );

  // ============================================================
  // INITIALIZE ADDRESS
  // Called from Splash
  // ============================================================

  Future<void> initializeAddress() async {
    emit(
      state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      // ========================================================
      // 1. GET USER LOCATION
      // ========================================================

      Position? position;

      try {
        position = await _locationService.getCurrentPosition();

        // if (position != null) {
        //   debugPrint(
        //     'USER LOCATION: '
        //     '${position.latitude}, ${position.longitude}',
        //   );
        // }
      } catch (e) {
        debugPrint(
          'LOCATION NOT AVAILABLE: $e',
        );
      }

      // ========================================================
      // 2. GET ADDRESSES FROM API
      // ========================================================

      final response = await _getAllUserAddressesUseCase();

      switch (response) {
        case SuccessResponse<List<AddressEntity>>():
          final addresses = response.data ?? [];

          // debugPrint(
          //   'ADDRESSES COUNT: ${addresses.length}',
          // );

          // ====================================================
          // NO ADDRESSES
          // ====================================================

          if (addresses.isEmpty) {
            emit(
              state.copyWith(
                addressesState:
                    state.addressesState.copyWith(
                  data: const [],
                  isLoading: false,
                  errorMessage: null,
                ),
                clearSelectedAddress: true,
              ),
            );

            return;
          }

          // ====================================================
          // 3. FIND NEAREST ADDRESS
          // ====================================================

          AddressEntity? nearestAddress;

          if (position != null) {
            nearestAddress = _findNearestAddress(
              addresses,
              position,
            );
          }

          // ====================================================
          // 4. LOCATION UNAVAILABLE
          // USE EXISTING DEFAULT
          // ====================================================

          nearestAddress ??=
              _findDefaultAddress(addresses);

          // ====================================================
          // 5. NO DEFAULT
          // USE FIRST ADDRESS
          // ====================================================

          nearestAddress ??= addresses.first;

          // debugPrint(
          //   'SELECTED ADDRESS: '
          //   '${nearestAddress.addressLine}',
          // );

          // debugPrint(
          //   'SELECTED ADDRESS ID: '
          //   '${nearestAddress.id}',
          // );

          // ====================================================
          // 6. IF GPS WAS AVAILABLE
          // MAKE NEAREST ADDRESS DEFAULT
          // ====================================================

          if (position != null) {
            final currentDefault =
                _findDefaultAddress(addresses);

            // Only call PATCH if the nearest address
            // isn't already the default.
            if (currentDefault?.id != nearestAddress.id) {
              debugPrint(
                'CHANGING DEFAULT ADDRESS TO: '
                '${nearestAddress.id}',
              );

              await _makeAddressDefault(
                nearestAddress,
                addresses,
              );

              return;
            }
          }

          // ====================================================
          // 7. SAVE ADDRESS IN STATE
          // ====================================================

          emit(
            state.copyWith(
              addressesState:
                  state.addressesState.copyWith(
                data: addresses,
                isLoading: false,
                errorMessage: null,
              ),
              selectedAddress: nearestAddress,
            ),
          );

        case ErrorResponse<List<AddressEntity>>():
          debugPrint(
            'GET ADDRESSES ERROR: '
            '${response.errorMessage}',
          );

          emit(
            state.copyWith(
              addressesState:
                  state.addressesState.copyWith(
                data: const [],
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
              clearSelectedAddress: true,
            ),
          );
      }
    } catch (e, stackTrace) {
      debugPrint(
        'INITIALIZE ADDRESS ERROR: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      emit(
        state.copyWith(
          addressesState:
              state.addressesState.copyWith(
            data: const [],
            isLoading: false,
            errorMessage: e.toString(),
          ),
          clearSelectedAddress: true,
        ),
      );
    }
  }

  // ============================================================
  // MAKE NEAREST ADDRESS DEFAULT
  // ============================================================

  Future<void> _makeAddressDefault(
    AddressEntity nearestAddress,
    List<AddressEntity> addresses,
  ) async {
    emit(
      state.copyWith(
        addressesState:
            state.addressesState.copyWith(
          data: addresses,
          isLoading: true,
          errorMessage: null,
        ),
        selectedAddress: nearestAddress,
      ),
    );

    try {
      final response =
          await _setDefaultAddressUseCase(
        nearestAddress.id,
      );

      switch (response) {
        case SuccessResponse<DefaultAddressEntity>():
          final defaultAddress = response.data;

          if (defaultAddress == null) {
            // debugPrint(
            //   'PATCH SUCCESS BUT RESPONSE DATA IS NULL',
            // );

            // Still use the nearest address locally.
            emit(
              state.copyWith(
                addressesState:
                    state.addressesState.copyWith(
                  data: addresses,
                  isLoading: false,
                  errorMessage: null,
                ),
                selectedAddress: nearestAddress,
              ),
            );

            return;
          }

          // debugPrint(
          //   'DEFAULT ADDRESS UPDATED: '
          //   '${defaultAddress.addressId}',
          // );

          // Refresh addresses so isDefault values
          // come from the backend.
          await _refreshAddresses(
            defaultAddress,
          );

        case ErrorResponse<DefaultAddressEntity>():
          // debugPrint(
          //   'SET DEFAULT ERROR: '
          //   '${response.errorMessage}',
          // );

          // PATCH failed.
          // Still show nearest address locally.
          emit(
            state.copyWith(
              addressesState:
                  state.addressesState.copyWith(
                data: addresses,
                isLoading: false,
                errorMessage: null,
              ),
              selectedAddress: nearestAddress,
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                isLoading: false,
                errorMessage: response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      // debugPrint(
      //   'MAKE DEFAULT ERROR: $e',
      // );

      // Don't prevent the user from entering Home
      // if PATCH fails.
      emit(
        state.copyWith(
          addressesState:
              state.addressesState.copyWith(
            data: addresses,
            isLoading: false,
            errorMessage: null,
          ),
          selectedAddress: nearestAddress,
          setDefaultAddressState:
              state.setDefaultAddressState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  // ============================================================
  // FIND NEAREST ADDRESS
  // ============================================================

  AddressEntity? _findNearestAddress(
    List<AddressEntity> addresses,
    Position position,
  ) {
    if (addresses.isEmpty) {
      return null;
    }

    AddressEntity? nearestAddress;

    double shortestDistance = double.infinity;

    for (final address in addresses) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        address.lat,
        address.lng,
      );

      // debugPrint(
      //   '${address.addressLine} '
      //   '→ ${distance.toStringAsFixed(2)} meters',
      // );

      if (distance < shortestDistance) {
        shortestDistance = distance;
        nearestAddress = address;
      }
    }

    if (nearestAddress != null) {
      debugPrint(
        '========================================',
      );

      // debugPrint(
      //   'NEAREST ADDRESS: '
      //   '${nearestAddress.addressLine}',
      // );

      // debugPrint(
      //   'NEAREST ID: '
      //   '${nearestAddress.id}',
      // );

      // debugPrint(
      //   'DISTANCE: '
      //   '${shortestDistance.toStringAsFixed(2)} meters',
      // );

      // debugPrint(
      //   '========================================',
      // );
    }

    return nearestAddress;
  }

  // ============================================================
  // FIND DEFAULT ADDRESS
  // ============================================================

  AddressEntity? _findDefaultAddress(
    List<AddressEntity> addresses,
  ) {
    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return null;
  }

  // ============================================================
  // MANUAL SELECT
  // ============================================================

  void selectAddress(
    AddressEntity address,
  ) {
    emit(
      state.copyWith(
        selectedAddress: address,
      ),
    );
  }

  // ============================================================
  // MANUAL SET DEFAULT
  // ============================================================

  Future<void> setDefaultAddress(
    String addressId,
  ) async {
    emit(
      state.copyWith(
        setDefaultAddressState:
            state.setDefaultAddressState.copyWith(
          isLoading: true,
          errorMessage: null,
        ),
      ),
    );

    try {
      final response =
          await _setDefaultAddressUseCase(
        addressId,
      );

      switch (response) {
        case SuccessResponse<DefaultAddressEntity>():
          final defaultAddress = response.data;

          if (defaultAddress == null) {
            emit(
              state.copyWith(
                setDefaultAddressState:
                    state.setDefaultAddressState.copyWith(
                  isLoading: false,
                  errorMessage:
                      'Default address response is empty.',
                ),
              ),
            );

            return;
          }

          await _refreshAddresses(
            defaultAddress,
          );

        case ErrorResponse<DefaultAddressEntity>():
          emit(
            state.copyWith(
              setDefaultAddressState:
                  state.setDefaultAddressState.copyWith(
                isLoading: false,
                errorMessage:
                    response.errorMessage,
              ),
            ),
          );
      }
    } catch (e) {
      emit(
        state.copyWith(
          setDefaultAddressState:
              state.setDefaultAddressState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  // ============================================================
  // REFRESH AFTER PATCH
  // ============================================================

  Future<void> _refreshAddresses(
    DefaultAddressEntity defaultAddress,
  ) async {
    final response =
        await _getAllUserAddressesUseCase();

    switch (response) {
      case SuccessResponse<List<AddressEntity>>():
        final addresses = response.data ?? [];

        AddressEntity? selectedAddress;

        for (final address in addresses) {
          if (address.id ==
              defaultAddress.addressId) {
            selectedAddress = address;
            break;
          }
        }

        selectedAddress ??=
            _findDefaultAddress(addresses);

        selectedAddress ??=
            addresses.isNotEmpty
                ? addresses.first
                : null;

        emit(
          state.copyWith(
            addressesState:
                state.addressesState.copyWith(
              data: addresses,
              isLoading: false,
              errorMessage: null,
            ),
            selectedAddress: selectedAddress,
            setDefaultAddressState:
                state.setDefaultAddressState.copyWith(
              data: defaultAddress,
              isLoading: false,
              errorMessage: null,
            ),
          ),
        );

      case ErrorResponse<List<AddressEntity>>():
        emit(
          state.copyWith(
            addressesState:
                state.addressesState.copyWith(
              isLoading: false,
              errorMessage: null,
            ),
            setDefaultAddressState:
                state.setDefaultAddressState.copyWith(
              data: defaultAddress,
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}