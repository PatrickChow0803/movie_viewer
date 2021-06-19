class CastList {
  final List<Cast> cast;

  CastList(this.cast);
}

class Cast {
  final String? name;
  final String? profilePath;
  final String? character;

  Cast({this.name, this.profilePath, this.character});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
        name: json['name'],
        profilePath: json['profile_path'],
        character: json['character']);
  }
}
