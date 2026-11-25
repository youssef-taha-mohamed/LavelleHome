import '../../../../shared/model/api_response.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_info.dart';
import '../../domain/entities/parameter/add_parameter.dart';
import '../../domain/entities/parameter/manual_payment.dart';
import '../../domain/entities/parameter/subscription_parameter.dart';
import '../../domain/entities/payment_info.dart';
import '../../domain/entities/summary.dart';
import '../../domain/repository/repository.dart';
import '../datasource/base/datasource.dart';
import '../module/cart.dart';
import '../module/cart_info.dart';
import '../module/parameter/payment_parameter.dart';
import '../module/parameter/subscription_parameter.dart';
import '../module/payment_info.dart';
import '../module/summary.dart';

class CartRepository implements CartBaseRepository {
  CartRepository({required this._dataSource});

  final CartBaseDataSource _dataSource;

  @override
  Future<ApiResponse<CartInfo>> add({
    required CartParameters parameters,
  }) async {
    final result = await _dataSource.add(parameters: parameters);
    return result.map((recordMap) {
      return CartInfoDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<CartInfo>> delete({
    required CartParameters parameters,
  }) async {
    final result = await _dataSource.delete(parameters: parameters);
    return result.map((recordMap) {
      return CartInfoDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<CartModel>> list({required num cartId}) async {
    final result = await _dataSource.list(cartId: cartId);
    return result.map((recordMap) {
      return CartDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse> subscription({
    required String userId,
    required num planId,
  }) async {
    final response = await _dataSource.subscription(
      userId: userId,
      planId: planId,
    );
    return response;
  }

  @override
  Future<ApiResponse<CartInfo>> getCartId({String? childId}) async {
    final result = await _dataSource.getCartId(childId: childId);
    return result.map((recordMap) {
      return CartInfoDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<OrderSummary>> summary({required num cartId}) async {
    final result = await _dataSource.summary(cartId: cartId);
    return result.map((recordMap) {
      return OrderSummaryDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<PaymentInfo>> paymentMethods() async {
    final result = await _dataSource.paymentMethods();
    return result.map((recordMap) {
      return PaymentInfoDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<SubscriptionParameter>> executePayment({
    required ExecutePaymentPara parameters,
  }) async {
    final result = await _dataSource.executePayment(parameters: parameters);
    return result.map((recordMap) {
      return SubscriptionParameterDTO.fromMap(recordMap);
    });
  }

  @override
  Future<ApiResponse<Map>> manualPayment({
    required ManualPaymentParameter parameters,
  }) async {
    final result = await _dataSource.manualPayment(parameters: parameters);
    return result;
  }
}
