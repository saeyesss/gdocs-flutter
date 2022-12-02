import 'package:gdocs_flutter/constants.dart';
import 'package:http/http.dart' as http;
import 'package:gdocs_flutter/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: http.Client(),
  ),
);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final http.Client _client;

  AuthRepository(
      {required GoogleSignIn googleSignIn, required http.Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  void signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: "",
          token: "",
        );

        var res = await _client.post(
          Uri.parse("$host/api/signup"),
          body: userAcc.toJson(),
          headers: {"Content-Type": "application/json; charSet=UTF-8"},
        );

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)["user"]["_id"],
            );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
