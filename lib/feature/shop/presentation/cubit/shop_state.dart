part of 'shop_cubit.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

class ShopInitial extends ShopState {
  const ShopInitial();
}

class ShopLoading extends ShopState {
  const ShopLoading();
}

class ShopLoaded extends ShopState {
  final List<CourseShop> courses;
  final List<CourseShop> filteredCourses;
  final List<CourseShop> cart;
  final List<String> favorites;
  final String selectedCategory;
  final List<ShopCategory> categories;
  final double totalPrice;

  const ShopLoaded({
    required this.courses,
    required this.filteredCourses,
    required this.cart,
    required this.favorites,
    required this.selectedCategory,
    required this.categories,
    required this.totalPrice,
  });

  @override
  List<Object> get props => [
    courses,
    filteredCourses,
    cart,
    favorites,
    selectedCategory,
    categories,
    totalPrice,
  ];

  ShopLoaded copyWith({
    List<CourseShop>? courses,
    List<CourseShop>? filteredCourses,
    List<CourseShop>? cart,
    List<String>? favorites,
    String? selectedCategory,
    List<ShopCategory>? categories,
    double? totalPrice,
  }) {
    return ShopLoaded(
      courses: courses ?? this.courses,
      filteredCourses: filteredCourses ?? this.filteredCourses,
      cart: cart ?? this.cart,
      favorites: favorites ?? this.favorites,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object> get props => [message];
}