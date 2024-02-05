import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/services/user_service.dart';
import 'package:http/http.dart' as http;

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
const String serverUrl = 'https://i10a603.p.ssafy.io';
Map<String, String> reqHeaders = checkTesting();

// POST /matchings/choice
Future<Map<String, String>?> postChoice(String partnerUserId) async {
  final response = await http.post(Uri.parse('$serverUrl/matchings/choice'),
      headers: reqHeaders, body: jsonEncode({"partnerId": partnerUserId}));

  if (response.statusCode == 200) {
    // matching 성공 start webrtc
    return jsonDecode(response.body);
  } else if (response.statusCode == 204) {
    // request 성공, matching pending
  } else {
    throw Exception("postChoice request failed");
  }
}

// GET /matchings/profile
Future<