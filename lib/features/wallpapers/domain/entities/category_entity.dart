class CategoryEntity {
  final String id;
  final String name;
  final String slug;
  final String? imageUrl;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });
}
