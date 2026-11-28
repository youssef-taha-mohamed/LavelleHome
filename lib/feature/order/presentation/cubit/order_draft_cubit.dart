import '../../../../shared/widgets/shared_widgets.dart';
import '../../../laundry/data/laundry_details.dart';
import '../../domain/order_line.dart';
import '../../domain/order_pricing.dart';

part 'order_draft_state.dart';

class OrderDraftCubit extends Cubit<OrderDraftState> {
  OrderDraftCubit() : super(const OrderDraftState());

  static String keyOf(
    ServiceGroup group,
    PriceItem item, [
    GarmentFinish? finish,
  ]) => '${group.id}|${item.name}|${finish?.name ?? ''}';

  /// بدء طلب من مغسلة. لو مغسلة مختلفة عن السابقة تُمسح المسودة،
  /// ولو نفسها نحتفظ بالأسطر ونحدّث رسوم التوصيل فقط.
  void start({
    required String laundryId,
    required String laundryName,
    double? deliveryFee,
  }) {
    final same = state.laundryId == laundryId;
    emit(
      OrderDraftState(
        laundryId: laundryId,
        laundryName: laundryName,
        deliveryFee: deliveryFee,
        lines: same ? state.lines : const {},
      ),
    );
  }

  void setQuantity(
    ServiceGroup group,
    PriceItem item,
    double quantity, {
    GarmentFinish? finish,
  }) {
    final key = keyOf(group, item, finish);
    final next = Map<String, OrderLine>.of(state.lines);

    if (quantity <= 0) {
      next.remove(key);
    } else {
      next[key] = OrderLine(
        key: key,
        groupId: group.id,
        groupName: group.name,
        kind: group.kind,
        itemName: item.name,
        unit: item.unit,
        unitPrice: item.price,
        quantity: quantity,
        finish: finish,
      );
    }

    emit(
      OrderDraftState(
        laundryId: state.laundryId,
        laundryName: state.laundryName,
        deliveryFee: state.deliveryFee,
        lines: next,
      ),
    );
  }

  void increment(ServiceGroup group, PriceItem item, {GarmentFinish? finish}) =>
      setQuantity(
        group,
        item,
        state.quantityOf(keyOf(group, item, finish)) + 1,
        finish: finish,
      );

  void decrement(ServiceGroup group, PriceItem item, {GarmentFinish? finish}) =>
      setQuantity(
        group,
        item,
        state.quantityOf(keyOf(group, item, finish)) - 1,
        finish: finish,
      );

  /// بعد إرسال الطلب أو إلغاؤه
  void clear() => emit(const OrderDraftState());
}
