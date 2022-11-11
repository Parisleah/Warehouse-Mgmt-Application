const String tableProfile = 'profile';

class ProfileFields {
  static final List<String> values = [id, name, phone, image, pin];

  static final String id = '_id';
  static final String name = 'name';
  static final String phone = 'phone';
  static final String image = 'image';

  static final String pin = 'pin';
}

class Profile {
  final int? id;
  final String name;
  late final String phone;
  final String image;
  final String pin;

  Profile({
    this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.pin,
  });
  Profile copy({
    int? id,
    String? name,
    String? phone,
    String? image,
    String? pin,
  }) =>
      Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        image: image ?? this.image,
        pin: pin ?? this.pin,
      );
  static Profile fromJson(Map<String, Object?> json) => Profile(
        id: json[ProfileFields.id] as int,
        name: json[ProfileFields.name] as String,
        phone: json[ProfileFields.phone] as String,
        image: json[ProfileFields.image] as String,
        pin: json[ProfileFields.pin] as String,
      );
  Map<String, Object?> toJson() => {
        ProfileFields.id: id,
        ProfileFields.name: name,
        ProfileFields.phone: phone,
        ProfileFields.image: image,
        ProfileFields.pin: pin,
      };
}
