import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/app_logo.dart';
import '../../../../address/domain/entities/address.dart';
import '../../../data/home_model.dart';
import '../../../data/home_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  /// يُرجع الموقع المختار وقت التحميل (من LocationCubit)
  final SelectedLocation? Function() _currentLocation;

  HomeCubit(this._repository, {required this._currentLocation})
    : super(const HomeState());

  /// [silent] = true أثناء السحب للتحديث (بدون عودة لهيكل التحميل)
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: LavelleViewStatus.loading));

    try {
      final data = await _repository.fetchHome(location: _currentLocation());
      emit(
        HomeState(
          status: LavelleViewStatus.success,
          banners: data.banners,
          laundries: data.laundries,
          selectedService: state.selectedService,
        ),
      );
    } on NoConnectionException {
      emit(state.copyWith(status: LavelleViewStatus.noConnection));
    } catch (e) {
      emit(
        state.copyWith(
          status: LavelleViewStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// الضغط على نفس الفئة مرة ثانية يلغي الفلتر
  void selectService(LaundryServiceType? type) {
    if (type == null || type == state.selectedService) {
      emit(state.copyWith(clearSelectedService: true));
    } else {
      emit(state.copyWith(selectedService: type));
    }
  }
}

// class HomeCubit extends Cubit<HomeState> {
//   final HomeRepository _repository;

//   HomeCubit(this._repository) : super(const HomeState());

//   /// [silent] = true أثناء السحب للتحديث (بدون عودة لهيكل التحميل)
//   Future<void> load({bool silent = false}) async {
//     if (!silent) emit(state.copyWith(status: LavelleViewStatus.loading));

//     try {
//       final data = await _repository.fetchHome();
//       emit(
//         HomeState(
//           status: LavelleViewStatus.success,
//           banners: data.banners,
//           laundries: data.laundries,
//           locationLabel: data.locationLabel,
//           selectedService: state.selectedService,
//         ),
//       );
//     } on NoConnectionException {
//       emit(state.copyWith(status: LavelleViewStatus.noConnection));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: LavelleViewStatus.error,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }

//   /// الضغط على نفس الفئة مرة ثانية يلغي الفلتر
//   void selectService(LaundryServiceType? type) {
//     if (type == null || type == state.selectedService) {
//       emit(state.copyWith(clearSelectedService: true));
//     } else {
//       emit(state.copyWith(selectedService: type));
//     }
//   }
// }
