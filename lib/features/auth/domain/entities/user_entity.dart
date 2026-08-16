import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String name;
  // final String token;

  const UserEntity({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    // required this.token,
  });

  @override
  List<Object?> get props => [id, email, phone, name];
}
  