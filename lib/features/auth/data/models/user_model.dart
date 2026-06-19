import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fittrack/features/auth/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.email,
    //V2=> required super.createdAt,
  });

  factory AppUserModel.fromUser(User user) {
    return AppUserModel(
      id: user.id,
      email: user.email ?? '',
      //Version 2 => fullName: fullName ?? user.userMetadata?['full_name'] as String? ?? '',
    );
  }

  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'] as String,
      email: map['email'] as String? ?? '',
      //Version 2 => fullName: map['full_name'] as String? ?? '',
    );
  }

  AppUserModel copyWith({String? id, String? email, String? fullName}) {
    return AppUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      //fullName: fullName ?? this.fullName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // matches DB column — NOT 'fullName'
      'email': email,
      // created_at intentionally omitted — DB default handles it
    };
  }

  @override
  String toString() => 'AppUserModel(id: $id, email: $email)';
}
