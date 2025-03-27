class FontModel {
  final String name;
  final String? fontFamily;
  final String? url;
  final bool isFavorite;
  final List<String> tags;
  final String description;
  final int year;
  final String designer;

  FontModel({
    required this.name,
    this.fontFamily,
    this.url,
    this.isFavorite = false,
    this.tags = const [],
    this.description = '',
    this.year = 0,
    this.designer = '',
  });

  FontModel copyWith({
    String? name,
    String? fontFamily,
    String? url,
    bool? isFavorite,
    List<String>? tags,
    String? description,
    int? year,
    String? designer,
  }) {
    return FontModel(
      name: name ?? this.name,
      fontFamily: fontFamily ?? this.fontFamily,
      url: url ?? this.url,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      year: year ?? this.year,
      designer: designer ?? this.designer,
    );
  }

  @override
  String toString() {
    return 'FontModel(name: $name, fontFamily: $fontFamily, year: $year, designer: $designer)';
  }
} 