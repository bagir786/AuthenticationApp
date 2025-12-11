import 'package:flutter_bloc/flutter_bloc.dart';

class AppUser {
  final String uid;
  final String email;

  AppUser({required this.uid, required this.email});

  // covert app user -> json
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email};
  }

  // convert json ->
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(uid: jsonUser['uid'], email: jsonUser['email']);
  }
}
