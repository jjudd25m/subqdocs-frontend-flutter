class FilterPastVisitStatusCategoryModel {
  String category;
  List<String> subcategories;

  // Constructor
  FilterPastVisitStatusCategoryModel({
    required this.category,
    required this.subcategories,
  });

  // To convert a CategoryModel to a map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'subcategories': subcategories,
    };
  }

  // To create a CategoryModel from a map (for JSON deserialization)
  factory FilterPastVisitStatusCategoryModel.fromMap(Map<String, dynamic> map) {
    return FilterPastVisitStatusCategoryModel(
      category: map['category'] ?? '',
      subcategories: List<String>.from(map['subcategories'] ?? []),
    );
  }

  // Optional: ToString method for easy logging
  @override
  String toString() {
    return 'CategoryModel(category: $category, subcategories: $subcategories)';
  }
}
