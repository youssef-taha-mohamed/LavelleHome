import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/authentication/provider.dart';
import '../../../../shared/model/api_response.dart';
import '../../../user/domain/entities/user_details.dart';
import '../../data/module/parameter/payment_parameter.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_info.dart';
import '../../domain/entities/parameter/add_parameter.dart';
import '../../domain/entities/parameter/subscription_parameter.dart';
import '../../domain/entities/payment_info.dart';
import '../../domain/enum/payment_enum.dart';
import '../../domain/repository/repository.dart';
import '../../domain/use_case/add.dart';
import '../../domain/use_case/delete.dart';
import '../../domain/use_case/get_cart_id.dart';
import '../../domain/use_case/list.dart';
import '../../domain/use_case/payment.dart';
import '../../domain/use_case/payment_methods.dart';
import '../../domain/use_case/manual_payment.dart';
import '../../domain/entities/parameter/manual_payment.dart';

enum CartProviderState {
  initial,
  loading,
  loadingId,
  processing,
  success,
  successId,
  paymentMethodsSuccess,
  paymentMethodsLoading,
  paymentLoading,
  paymentSuccess,
  deleteSuccess,
  manualPaymentLoading,
  manualPaymentSuccess,
  manualPaymentError,
  deleteError,
  error,
  stale,
}

class CartProvider extends ChangeNotifier {
  final CartBaseRepository _repository;
  static late final CartProvider instance;

  static void init({required CartBaseRepository repository}) {
    instance = CartProvider._(repository: repository);
  }

  CartProvider._({required this._repository});

  CartInfo? cartInfo;
  CartModel? cartModel;
  List<PaymentEnum> payment = [];
  PaymentEnum? selectedPaymentMethod;
  SubscriptionParameter? paymentParameter;
  File? attachedReceipt;
  List<BankAccount> bankAccounts = [];
  final TextEditingController noteController = TextEditingController();

  UserDetails? get user => AuthenticationProvider.instance.currentUser?.details;

  CartProviderState _state = CartProviderState.initial;

  CartProviderState get state => _state;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  String? _successMessage;

  String? get successMessage => _successMessage;

  bool _isLoadingId = false;

  void markCartAsStale() {
    if (_state != CartProviderState.stale) {
      log('CART_PROVIDER_STATE: Setting state to STALE (from $_state)');
      _state = CartProviderState.stale;
      _setState(CartProviderState.stale);
    }
  }

  void _setState(CartProviderState newState) {
    log('CART_PROVIDER_STATE: Setting state from $_state to $newState');
    _state = newState;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentEnum method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<void> pickReceipt({
    required bool isPdf,
    ImageSource imageSource = ImageSource.gallery,
  }) async {
    const int maxFileSizeInBytes = 2 * 1024 * 1024; // 2 MB

    int fileSize = 0;
    String? filePath;
    String? fileName;
    Uint8List? fileBytes;

    if (isPdf) {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: kIsWeb,
      );
      if (result != null) {
        fileSize = result.files.single.size;
        filePath = result.files.single.path;
        fileName = result.files.single.name;
        fileBytes = result.files.single.bytes;
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: imageSource);
      if (image != null) {
        fileSize = await image.length();
        filePath = image.path;
        fileName = image.name;
        fileBytes = await image.readAsBytes();
      }
    }

    if (fileSize > 0) {
      if (fileSize > maxFileSizeInBytes) {
        _errorMessage = "حجم الملف المسموح به لا يمكن أن يتجاوز 2 ميجابايت";
        _setState(CartProviderState.error);
        return;
      }

      attachedReceiptBytes = fileBytes;
      attachedReceiptName =
          fileName ??
          filePath?.split('/').last ??
          (isPdf ? 'receipt.pdf' : 'receipt.jpg');

      if (!kIsWeb && filePath != null) {
        attachedReceipt = File(filePath);
      } else {
        attachedReceipt = null;
      }
      notifyListeners();
    }
  }

  Uint8List? attachedReceiptBytes;
  String? attachedReceiptName;

  void clearReceipt({bool notify = true}) {
    attachedReceipt = null;
    attachedReceiptBytes = null;
    attachedReceiptName = null;
    if (notify) {
      notifyListeners();
    }
  }

  void resetManualPayment({bool notify = true}) {
    attachedReceipt = null;
    attachedReceiptBytes = null;
    attachedReceiptName = null;
    noteController.clear();
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getCartItems({
    bool isBackgroundRefresh = false,
    bool preserveMessages = false,
  }) async {
    if (!isBackgroundRefresh) {
      _setState(CartProviderState.loading);
    }
    if (!preserveMessages) {
      _errorMessage = null;
      _successMessage = null;
    }

    try {
      final useCase = ListOfCart(repository: _repository);
      final ApiResponse<CartModel> result = await useCase.call(
        cartId: cartInfo?.cartId ?? 0,
      );
      if (result.status) {
        cartModel = result.record;
        _setState(CartProviderState.success);
      } else {
        _errorMessage = result.message;
        _setState(CartProviderState.error);
      }
    } catch (e, s) {
      log('Error Ya Youssef $e');
      log('Error Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.error);
    }
  }

  Future<void> putPayment({required ExecutePaymentPara parameters}) async {
    _setState(CartProviderState.paymentLoading);
    _errorMessage = null;
    _successMessage = null;

    try {
      final useCase = ExecutePaymentUseCase(repository: _repository);
      final ApiResponse<SubscriptionParameter> result = await useCase.call(
        parameters: parameters,
      );
      paymentParameter = result.record;
      _setState(CartProviderState.paymentSuccess);
    } catch (e, s) {
      log('Error Payment Ya Youssef $e');
      log('Error Payment Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.error);
    }
  }

  Future<void> putManualPayment({
    required ManualPaymentParameter parameters,
  }) async {
    _setState(CartProviderState.manualPaymentLoading);
    _errorMessage = null;
    _successMessage = null;

    try {
      final useCase = ManualPaymentUseCase(repository: _repository);
      final ApiResponse<Map> result = await useCase.call(
        parameters: parameters,
      );
      if (result.status) {
        _successMessage = result.message;
        _setState(CartProviderState.manualPaymentSuccess);
      } else {
        _errorMessage = result.message;
        _setState(CartProviderState.manualPaymentError);
      }
    } catch (e, s) {
      log('Error Manual Payment Ya Youssef $e');
      log('Error Manual Payment Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.manualPaymentError);
    }
  }

  Future<void> getPaymentMethods() async {
    _setState(CartProviderState.paymentMethodsLoading);
    _errorMessage = null;
    _successMessage = null;

    try {
      final useCase = PaymentMethodsUseCase(repository: _repository);
      final ApiResponse<PaymentInfo> result = await useCase.call();
      payment = result.record.availablePaymentGateways;
      bankAccounts = result.record.bankAccountLists;

      if (payment.isNotEmpty) {
        selectedPaymentMethod = payment.first;
      }
      _setState(CartProviderState.paymentMethodsSuccess);
    } catch (e, s) {
      log('Error Payment Methods Ya Youssef $e');
      log('Error Payment Methods Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.error);
    }
  }

  Future<void> addToCart({required num planId}) async {
    _setState(CartProviderState.processing);
    _errorMessage = null;
    _successMessage = null;
    try {
      final userId = user?.id;

      final useCase = AddToCart(repository: _repository);
      final ApiResponse<CartInfo> result = await useCase.call(
        parameters: CartParameters(
          cartId: cartInfo?.cartId ?? 0,
          userId: userId,
          planId: planId,
        ),
      );
      _successMessage = result.message;
      cartInfo = result.record;
      _setState(CartProviderState.success);
    } catch (e, s) {
      log('Error Ya Youssef $e');
      log('Error Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.error);
    }
  }

  Future<void> getCartId({String? childId}) async {
    if (_isLoadingId) {
      log('⏳ getCartId already in progress, skipping...');
      return;
    }
    _isLoadingId = true;
    _setState(CartProviderState.loadingId);
    try {
      // final userId = user?.role.id == UserRole.parent.id
      //     ? child?.childId ?? ""
      //     : user?.id ?? '';

      final useCase = GetCartId(repository: _repository);
      final ApiResponse<CartInfo> result = await useCase.call(childId: childId);
      cartInfo = result.record;
      //_setState(CartProviderState.success);
      // getCartItems(isBackgroundRefresh: false);
      _setState(CartProviderState.successId);
    } catch (e, s) {
      log('Error Ya Youssef $e');
      log('Error Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.error);
      // rethrow;
    } finally {
      _isLoadingId = false;
    }
  }

  Future<void> delete({required List<num> planIds}) async {
    _setState(CartProviderState.processing);
    _errorMessage = null;
    _successMessage = null;
    try {
      final useCase = DeleteCart(repository: _repository);
      final ApiResponse<CartInfo> result = await useCase.call(
        parameters: CartParameters(
          cartId: cartInfo?.cartId ?? 0,
          listIds: planIds,
        ),
      );
      if (result.status) {
        cartInfo = result.record;
        _successMessage = result.message;
        _setState(CartProviderState.deleteSuccess);
      } else {
        _errorMessage = result.message;
        _setState(CartProviderState.deleteError);
      }
    } catch (e, s) {
      log('Error Ya Youssef $e');
      log('Error Location Ya Youssef $s');
      String errorToShow = e.toString();

      if (e is DioException) {
        errorToShow = e.message ?? "";
      }
      _errorMessage = errorToShow;
      _setState(CartProviderState.deleteError);
    }
  }

  int get totalSessionCount {
    if (cartModel == null) {
      return 0;
    }
    return cartModel!.items.fold<int>(
      0,
      (previousValue, item) => previousValue + item.sessionCount,
    );
  }

  void clearError() {
    _errorMessage = null;
  }

  void clearSuccessMessage() {
    _successMessage = null;
  }

  Future<void> refresh() async {
    _setState(CartProviderState.loading);
    await getCartItems(isBackgroundRefresh: true, preserveMessages: false);
  }
}
