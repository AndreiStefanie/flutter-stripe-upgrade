import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final bool emailVerified;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
