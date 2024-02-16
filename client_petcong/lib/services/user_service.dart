import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/models/profile_page_model.dart';
import 'package:petcong/models/user_signup_model.dart';

const bool testing = false;

String idTokenString = "";

const String serverUrl = 'https://i10a603.p.ssafy.io';

// testing 중인지 확인하고 header에 tester 권한 추가
Future<Map<String, String>> getIdToken() async {
  if (testing) return {'tester': 'A603'};
  Map<String, String> postHeaders = {};
  if (FirebaseAuth.instance.currentUser != null) {
    if (kDebugMode) {
      print("user exists");
    }

    try {
      String? token = await FirebaseAuth.instance.currentUser!.getIdToken();
      if (token!.isNotEmpty) {
        postHeaders['Petcong-id-token'] = token;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
  return postHeaders;
}

// POST /members/signup
Future<void> postSignup(UserSignupModel user) async {
  Map<String, String> postHeaders = await getIdToken();
  postHeaders['Content-Type'] = 'application/json';
  if (kDebugMode) {
    print("headers");
  }
  postHeaders.forEach((key, value) {
    if (kDebugMode) {
      print("$key : $value");
    }
  });

  if (kDebugMode) {
    print("json body");
    print(jsonEncode(user.toJson()));
  }

  final response = await http.post(Uri.parse('$serverUrl/members/signup'),
      headers: postHeaders, body: jsonEncode(user.toJson()));

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
Future<bool> postSignin() async {
  Map<String, String> reqHeaders = await getIdToken();
  final response = await http.post(Uri.parse('$serverUrl/members/signin'),
      headers: reqHeaders);

  if (kDebugMode) {
    print("postSignIn requestHeader: $reqHeaders");
  }

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("postSignin success");
      print("postSignin response body: ${response.body}");
    }
    return true;
  } else {
    if (kDebugMode) {
      print("postSignin response status code: ${response.statusCode}");
      print("postSignin response body: ${response.body}");
      print("error");
    }
    return false;
  }
}

// GET /members/info
Future<ProfilePageModel> getUserInfo() async {
  Map<String, String> reqHeaders = await getIdToken();
  final response =
      await http.get(Uri.parse('$serverUrl/members/info'), headers: reqHeaders);

  if (response.statusCode == 200) {
    return ProfilePageModel.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("user doesn't exist.");
  }
}

// GET /members/info/{memberId}
Future<ProfilePageModel> getCallUserInfo(int memberId) async {
  Map<String, String> reqHeaders = await getIdToken();
  final response = await http
      .get(Uri.parse('$serverUrl/members/info/$memberId'), headers: reqHeaders);

  if (response.statusCode == 200) {
    return ProfilePageModel.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    if (kDebugMode) {
      print("getCallUserInfo response.statusCode: ${response.statusCode}");
      print("getCallUserInfo response.body: ${response.body}");
      print("error");
    }
    throw Exception("user doesn't exist.");
  }
}

// PATCH /members/update
Future<void> patchUserInfo(UserSignupModel user) async {
  Map<String, String> reqHeaders = await getIdToken();
  reqHeaders['Content-Type'] = 'application/json';
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
  Map<String, String> reqHeaders = await getIdToken();
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
      print("postPicture response status code: ${response.statusCode}");
      print("error");
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
  Map<String, String> reqHeaders = await getIdToken();
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

// GET /members/picture
Future<String> getPicture(String key) async {
  Map<String, String> reqHeaders = await getIdToken();
  final response = await http.get(
      Uri.parse('$serverUrl/members/picture?key=$key'),
      headers: reqHeaders);

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("success");
      print(response.body);
    }
    return response.body;
  } else {
    if (kDebugMode) {
      print(response.statusCode);
      print(response.body);
      print("error");
    }
    throw Exception("Failed to get picture");
  }
}
