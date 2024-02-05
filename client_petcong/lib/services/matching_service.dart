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

Future<dynamic> postMatching(int targetUserId) async {
  const endpoint = '$serverUrl/matchings/choice';
  final response = await http.post(Uri.parse(endpoint),
      headers: reqHeaders, body: jsonEncode({'partnerUserId': targetUserId}));

  if (response.statusCode == 200) {
    // matched
    String targetLink = jsonDecode(response.body)['targetLink'];
    print('targetLink = ' + targetLink);
    return targetLink;
  } else if (response.statusCode == 204) {
    print("pending처리 됨");
    return;
  } else {
    if (kDebugMode) {
      print('code = ' + response.statusCode.toString());
      print('errMsg = ' + response.body);
    } else {
      throw Exception("invalid matching request");
    }
  }
}

Map<String, String> checkTesting() {
  return testing ? {'tester': 'A603'} : {'Petcong-id-token': idTokenString};
}
