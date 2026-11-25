import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'shop_state.dart';

class CourseShop extends Equatable {
  final String id;
  final String name;
  final String category;
  final int price;
  final int originalPrice;
  final String image;
  final double rating;
  final int students;
  final String? badge;
  final String ageGroup;

  const CourseShop({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.rating,
    required this.students,
    this.badge,
    required this.ageGroup,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    originalPrice,
    image,
    rating,
    students,
    badge,
    ageGroup,
  ];
}

class ShopCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const ShopCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, icon];
}

class ShopCubit extends Cubit<ShopState> {
  ShopCubit() : super(const ShopInitial());

  final List<CourseShop> _allCourses = [
    CourseShop(
      id: '1',
      name: 'البرمجة للأطفال',
      category: 'programming',
      price: 299,
      originalPrice: 499,
      image: '📱',
      rating: 4.8,
      students: 2450,
      badge: 'جديد',
      ageGroup: '8-12 سنة',
    ),
    CourseShop(
      id: '2',
      name: 'الرياضيات الممتعة',
      category: 'math',
      price: 199,
      originalPrice: 349,
      image: '🔢',
      rating: 4.9,
      students: 3120,
      ageGroup: '6-10 سنة',
    ),
    CourseShop(
      id: '3',
      name: 'اللغة الإنجليزية',
      category: 'language',
      price: 249,
      originalPrice: 399,
      image: '🌍',
      rating: 4.7,
      students: 1890,
      badge: 'خصم',
      ageGroup: '7-12 سنة',
    ),
    CourseShop(
      id: '4',
      name: 'الفن والإبداع',
      category: 'art',
      price: 179,
      originalPrice: 299,
      image: '🎨',
      rating: 4.6,
      students: 1560,
      ageGroup: '5-11 سنة',
    ),
    CourseShop(
      id: '5',
      name: 'العلوم المرحة',
      category: 'science',
      price: 279,
      originalPrice: 449,
      image: '🔬',
      rating: 4.9,
      students: 2890,
      badge: 'الأكثر طلباً',
      ageGroup: '8-12 سنة',
    ),
    CourseShop(
      id: '6',
      name: 'القراءة الإبداعية',
      category: 'reading',
      price: 159,
      originalPrice: 279,
      image: '📚',
      rating: 4.5,
      students: 1240,
      ageGroup: '6-10 سنة',
    ),
  ];

  final List<ShopCategory> _categories = [
    const ShopCategory(id: 'all', name: 'الكل', icon: '⭐'),
    const ShopCategory(id: 'programming', name: 'برمجة', icon: '💻'),
    const ShopCategory(id: 'math', name: 'رياضيات', icon: '🔢'),
    const ShopCategory(id: 'language', name: 'لغات', icon: '🌍'),
    const ShopCategory(id: 'art', name: 'فن', icon: '🎨'),
  ];

  Future<void> loadCourses() async {
    try {
      emit(const ShopLoading());

      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        ShopLoaded(
          courses: _allCourses,
          filteredCourses: _allCourses,
          cart: [],
          favorites: [],
          selectedCategory: 'all',
          categories: _categories,
          totalPrice: 0,
        ),
      );
    } catch (e) {
      emit(ShopError('حدث خطأ في تحميل الدورات'));
    }
  }

  void selectCategory(String categoryId) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final filtered = categoryId == 'all'
          ? currentState.courses
          : currentState.courses
          .where((course) => course.category == categoryId)
          .toList();

      emit(
        currentState.copyWith(
          selectedCategory: categoryId,
          filteredCourses: filtered,
        ),
      );
    }
  }

  void toggleFavorite(String courseId) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final updatedFavorites = List<String>.from(currentState.favorites);

      if (updatedFavorites.contains(courseId)) {
        updatedFavorites.remove(courseId);
      } else {
        updatedFavorites.add(courseId);
      }

      emit(
        currentState.copyWith(
          favorites: updatedFavorites,
        ),
      );
    }
  }

  void addToCart(CourseShop course) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;

      // تجنب إضافة نفس الدورة مرتين
      if (currentState.cart.any((item) => item.id == course.id)) {
        return;
      }

      final updatedCart = List<CourseShop>.from(currentState.cart)..add(course);
      final newTotalPrice = updatedCart.fold<double>(
        0,
            (sum, item) => sum + item.price,
      );

      emit(
        currentState.copyWith(
          cart: updatedCart,
          totalPrice: newTotalPrice,
        ),
      );
    }
  }

  void removeFromCart(String courseId) {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      final updatedCart = currentState.cart
          .where((item) => item.id != courseId)
          .toList();

      final newTotalPrice = updatedCart.fold<double>(
        0,
            (sum, item) => sum + item.price,
      );

      emit(
        currentState.copyWith(
          cart: updatedCart,
          totalPrice: newTotalPrice,
        ),
      );
    }
  }

  void clearCart() {
    if (state is ShopLoaded) {
      final currentState = state as ShopLoaded;
      emit(
        currentState.copyWith(
          cart: [],
          totalPrice: 0,
        ),
      );
    }
  }
}