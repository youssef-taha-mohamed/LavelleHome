import 'package:equatable/equatable.dart';

// Entity
abstract class CourseEntity extends Equatable {
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

  const CourseEntity({
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

// Model
class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.originalPrice,
    required super.image,
    required super.rating,
    required super.students,
    super.badge,
    required super.ageGroup,
  });

  // From JSON
  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: json['price'] as int,
      originalPrice: json['originalPrice'] as int,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      students: json['students'] as int,
      badge: json['badge'] as String?,
      ageGroup: json['ageGroup'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'rating': rating,
      'students': students,
      'badge': badge,
      'ageGroup': ageGroup,
    };
  }

  // Copy With
  CourseModel copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    int? originalPrice,
    String? image,
    double? rating,
    int? students,
    String? badge,
    String? ageGroup,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      students: students ?? this.students,
      badge: badge ?? this.badge,
      ageGroup: ageGroup ?? this.ageGroup,
    );
  }
}

// Category
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  List<Object> get props => [id, name, icon];
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}