import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/models/user_signup_model.dart';

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
const String serverUrl = 'https://i10a603.p.ssafy.io';
Map<String, String> reqHeaders = checkTesting();

// POST /members/signup
Future<void> postSignup(UserSignupModel user) async {
  final response = await http.post(Uri.parse('$serverUrl/members/signup'),
      headers: {
        'tester': 'A603',
        'Content-Type': 'application/json',
      },
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

// POST /members/signin
// 가입한적이 있는 경우 true, 없는 경우 false를 반환합니다.
Future<bool> postSignin() async {
  final response = await http.post(Uri.parse('$serverUrl/members/signin'),
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

// GET /members/info
Future<ProfilePageModel> getUserInfo() async {
  final response =
      await http.get(Uri.parse('$serverUrl/members/info'), headers: reqHeaders);

  if (response.statusCode == 200) {
    return ProfilePageModel.fromJson(
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

// PATCH /members/update
Future<void> patchUserInfo(UserSignupModel user) async {
  final response = await http.patch(Uri.parse('$serverUrl/members/update'),
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

// POST /members/picture
Future<void> postPicture(List<String> filePaths) async {
  const String endpoint = '$serverUrl/members/picture';
  var request = http.MultipartRequest('POST', Uri.parse(endpoint));
  request.headers.addAll(reqHeaders);

  for (String filePath in filePaths) {
    var file = await http.MultipartFile.fromPath('files', filePath);
    request.files.add(file);
  }

  try {
    var response = await request.send();
    if (response.statusCode == 201) {
      if (kDebugMode) {
        print("pic posting success");
      }
    } else if (kDebugMode) {
      print("pic posting failed");
      print(response.statusCode);
      await for (var line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        print('Line: $line');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
  }
}

Future<void> patchPicture(List<String> keys, List<String> filePaths) async {
  var request = http.MultipartRequest(
      'PATCH', Uri.parse('$serverUrl/members/update/picture'));

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
  final response = await http.delete(Uri.parse('$serverUrl/members/withdraw'),
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
