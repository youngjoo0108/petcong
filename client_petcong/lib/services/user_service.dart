import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/user_model.dart';

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
Map<String, String> reqHeaders = checkTesting();

Future<UserModel> fetchAlbum() async {
  // ---- local testing
  // final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/info'),
  //     headers: {"tester": "A603"});

  // ---- server testing
  final response = await http.get(
      Uri.parse('http://i10a603.p.ssafy.io:8080/users/info'),
      headers: reqHeaders);

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    print(response.statusCode);
    print(response.body);
    print("error");
    throw Exception('Failed to load album.');
  }
}

Map<String, String> checkTesting() {
  if (testing == true) {
    return {
      'tester': 'A603',
    };
  } else {
    return {
      'Petcong-id-token': idTokenString,
    };
  }
}
