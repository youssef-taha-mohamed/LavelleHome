import '../../../../../shared/widgets/shared_widgets.dart';
import '../../../data/module/laundry_model.dart';
import '../../../domain/repository/laundry_repository.dart';
import '../../../data/laundry_details.dart';
import '../../../domain/repository/laundry_details_repo.dart';

part 'laundry_details_state.dart';

class LaundryDetailsCubit extends Cubit<LaundryDetailsState> {
  final LaundryDetailsRepository _repository;
  final String laundryId;

  LaundryDetailsCubit(this._repository, this.laundryId, {Laundry? preview})
    : super(LaundryDetailsState(preview: preview));

  Future<void> load() async {
    emit(LaundryDetailsState(preview: state.preview));
    try {
      final details = await _repository.fetchDetails(laundryId);
      emit(
        LaundryDetailsState(
          status: LavelleViewStatus.success,
          details: details,
          preview: state.preview,
        ),
      );
    } on NoConnectionException {
      emit(
        LaundryDetailsState(
          status: LavelleViewStatus.noConnection,
          preview: state.preview,
        ),
      );
    } catch (_) {
      emit(
        LaundryDetailsState(
          status: LavelleViewStatus.error,
          preview: state.preview,
        ),
      );
    }
  }
}
