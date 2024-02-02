import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/user_model.dart';

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
const String serverUrl = 'https://i10a603.p.ssafy.io';
Map<String, String> reqHeaders = checkTesting();

// GET /users/info
Future<UserModel> getUserInfo() async {
  // ---- local testing
  // final response = await http.get(Uri.parse('http://10.0.2.2:8080/users/info'),
  //     headers: {"tester": "A603"});

  // ---- server testing
  final response =
      await http.get(Uri.parse('$serverUrl/users/info'), headers: reqHeaders);

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("user doesn't exist.");
  }
}

Future<void> postPicture(List<String> filePaths) async {
  const String endpoint = '$serverUrl/users/picture';
  var request = http.MultipartRequest('POST', Uri.parse(endpoint));

  for (String filePath in filePaths) {
    var file = await http.MultipartFile.fromPath('files', filePath);
    request.files.add(file);
  }

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("success");
      }
    } else if (kDebugMode) {
      print("failed");
      print(response.statusCode);
      print(response.stream.bytesToString());
    }
  } catch (error) {
    if (kDebugMode) {
      print("error");
      print(error.toString());
    }
  }
}

Future<void> patchPicture(List<String> keys) async {
  Map<String, String> jsonBody = {'keys': keys.toString()};
}

Map<String, String> checkTesting() {
  return testing ? {'tester': 'A603'} : {'Petcong-id-token': idTokenString};
}
