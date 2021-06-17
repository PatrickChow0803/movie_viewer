class Genre {
  final int? id;
  final String? name;

  late String error;

  Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Genre();
    }
    return Genre(id: json['id'], name: json['name']);
  }
}
