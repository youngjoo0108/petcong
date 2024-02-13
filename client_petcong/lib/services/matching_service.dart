import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:get/get.dart';
import 'package:petcong/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class MatchingService extends GetxController {
const bool testing = true;

User? currentUser = UserController.currentUser;
// String idTokenString = currentUser?.getIdToken().toString() ?? "";
// User user = FirebaseAuth.instance.currentUser!;
// String? idToken;
const String serverUrl = 'http://i10a603.p.ssafy.io:8081';
// Map<String, String>? reqHeaders;

Future<dynamic> postMatching(String targetUid) async {
  print("postMatching 실행됨");
  // await initPrefs();
  Map<String, String> reqHeaders = await getIdToken();
  reqHeaders['Content-Type'] = "application/json";
  String endpoint = '$serverUrl/matchings/choice';
  final response = await http.post(Uri.parse(endpoint),
      headers: reqHeaders, body: jsonEncode({'partnerUid': targetUid}));
  if (response.statusCode == 200) {
    String body = response.body;
    return ChoiceRes.fromJson(jsonDecode(body));
  } else if (response.statusCode == 204) {
    return;
  } else {
    if (kDebugMode) {
      print('code = ${response.statusCode}');
      print('errMsg = ${response.body}');
    } else {
      throw Exception("invalid matching request");
    }
  }

  // Map<String, String> reqHeaders = checkTesting();
}

// GET /matchings/profile
Future<CardProfileModel> getProfile() async {
  Map<String, String> reqHeaders = await getIdToken();
  final response = await http.get(Uri.parse('$serverUrl/matchings/profile'),
      headers: reqHeaders);

  if (response.statusCode == 200) {
    if (kDebugMode) print(jsonDecode(response.body));
    return CardProfileModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("getProfile request failed");
  }
}

// GET /matchings/matchList
Future<List<CardProfileModel>> getMatchList() async {
  Map<String, String> reqHeaders = await getIdToken();
  final response = await http.get(Uri.parse('$serverUrl/matchings/list'),
      headers: reqHeaders);

  debugPrint("getMatchList request status: ${response.statusCode}");
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((e) => CardProfileModel.fromJson(e))
        .toList();
  } else {
    if (kDebugMode) {
      print("getMatchList request status: ${response.statusCode}");
      print("getMatchList response body: ${response.body}");
      print("getMatchList error");
    }
    throw Exception("getMatchList request failed");
  }
}
