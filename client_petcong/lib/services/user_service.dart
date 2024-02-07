import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/user_info_model.dart';
import 'package:petcong/models/user_model.dart';
import 'package:petcong/models/user_signup_model.dart';

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
const String serverUrl = 'https://i10a603.p.ssafy.io';
Map<String, String> reqHeaders = checkTesting();

// POST /users/signup
Future<void> postSignup(UserSignupModel user) async {
  print(user.toJson());

  final response = await http.post(Uri.parse('$serverUrl/members/signup'),
      headers: {'tester': 'A603', 'Content-Type': 'application/json',},
      body: jsonEncode(user.toJson()));
  
  if (response.statusCode == 201) {
    if (kDebugMode) {
      print("success");
    }
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("Failed to sign up");
  }
}

// POST /users/signin
// 가입한적이 있는 경우 true, 없는 경우 false를 반환합니다.
Future<bool> postSignin() async {
  final response = await http.post(Uri.parse('$serverUrl/users/signin'),
      headers: reqHeaders);

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("success");
    }
    return true;
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    return false;
  }
}

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

// PATCH /users/update
Future<void> patchUserInfo(UserInfoModel user) async {
  final response = await http.patch(Uri.parse('$serverUrl/users/update'),
      headers: reqHeaders, body: jsonEncode(user.toJson()));

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("success");
    }
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("Failed to update user info");
  }
}

Future<void> postPicture(List<String> filePaths) async {
  const String endpoint = '$serverUrl/users/picture';
  var request = http.MultipartRequest('POST', Uri.parse(endpoint));

  for (String filePath in filePaths) {
    var file = await http.MultipartFile.fromPath('file', filePath);
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

Future<void> patchPicture(List<String> keys, List<String> filePaths) async {
  var request = http.MultipartRequest(
      'PATCH', Uri.parse('$serverUrl/users/update/picture'));

  for (int i = 0; i < filePaths.length; i++) {
    var file = await http.MultipartFile.fromPath(keys[i], filePaths[i]);
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

Future<void> withdrawUser() async {
  final response = await http.delete(Uri.parse('$serverUrl/users/withdraw'),
      headers: reqHeaders);

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("success");
    }
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("Failed to withdraw user");
  }
}

// TODO: refactor to throw exception if idTokenString is null
Map<String, String> checkTesting() {
  return testing ? {'tester': 'A603'} : {'Petcong-id-token': idTokenString};
}
