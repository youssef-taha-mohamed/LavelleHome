import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../address/domain/entities/address.dart';
import '../../../address/domain/repository/address_repository.dart';
import '../../device_location_service.dart';
part 'location_state.dart';

// يُوفَّر مرة واحدة على مستوى التطبيق (فوق MaterialApp) ليراه الـ Shell والـ Checkout والخريطة.

class LocationCubit extends Cubit<LocationState> {
  final AddressRepository _addresses;
  final DeviceLocationService _device;

  LocationCubit(this._addresses, this._device) : super(const LocationState());

  Future<void> init() async {
    final list = await _addresses.list();
    final selectedId = await _addresses.getSelectedId();
    final permission = await _device.checkPermission();

    SelectedLocation? selected;
    for (final a in list) {
      if (a.id == selectedId) selected = SelectedLocation(address: a);
    }

    emit(
      LocationState(
        isLoading: false,
        addresses: list,
        selected: selected,
        permission: permission,
      ),
    );
  }

  Future<void> selectAddress(SavedAddress address) async {
    await _addresses.setSelectedId(address.id);
    emit(state.copyWith(selected: SelectedLocation(address: address)));
  }

  /// [select] = true يجعل العنوان الجديد هو موقع التصفح الحالي (الافتراضي).
  /// من شاشة الطلب نمرّر false حتى لا يتغير موقع الرئيسية.
  Future<SavedAddress> addAddress(
    AddressData data, {
    bool select = true,
  }) async {
    final saved = await _addresses.add(data);
    emit(state.copyWith(addresses: [...state.addresses, saved]));
    if (select) await selectAddress(saved);
    return saved;
  }

  Future<SavedAddress> updateAddress(String id, AddressData data) async {
    final saved = await _addresses.update(id, data);
    final wasSelected = state.selected?.address?.id == id;
    emit(
      state.copyWith(
        addresses: [for (final a in state.addresses) a.id == id ? saved : a],
        selected: wasSelected ? SelectedLocation(address: saved) : null,
      ),
    );
    return saved;
  }

  Future<void> deleteAddress(String id) async {
    await _addresses.delete(id);
    final wasSelected = state.selected?.address?.id == id;
    emit(
      state.copyWith(
        addresses: state.addresses.where((a) => a.id != id).toList(),
        clearSelected: wasSelected,
      ),
    );
  }

  /// true = تم تحديد الموقع الحالي واختياره
  Future<bool> useCurrentLocation() async {
    emit(state.copyWith(isLocating: true, locateFailed: false));

    final permission = await _device.requestPermission();
    if (permission != LocationPermissionStatus.granted) {
      emit(state.copyWith(isLocating: false, permission: permission));
      return false;
    }

    final point = await _device.currentPosition();
    if (point == null) {
      emit(
        state.copyWith(
          isLocating: false,
          locateFailed: true,
          permission: permission,
        ),
      );
      return false;
    }

    await _addresses.setSelectedId(null);
    emit(
      state.copyWith(
        isLocating: false,
        permission: permission,
        selected: SelectedLocation(point: point),
      ),
    );
    return true;
  }

  Future<void> openSettings() => _device.openSettings(state.permission);
}
