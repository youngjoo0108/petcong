import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:petcong/models/card_profile_model.dart';
import 'package:petcong/services/user_service.dart';

const bool testing = true;

User? currentUser = UserController.currentUser;
String idTokenString = currentUser?.getIdToken().toString() ?? "";
const String serverUrl = 'https://i10a603.p.ssafy.io';

Future<dynamic> postMatching(String targetUid) async {
  Map<String, String> reqHeaders = await getIdToken();
  String endpoint = '$serverUrl/matchings/choice';
  final response = await http.post(Uri.parse(endpoint),
      headers: reqHeaders, body: jsonEncode({'partnerUserUid': targetUid}));
  print("body === " + jsonDecode(response.body));

  if (response.statusCode == 200) {
    print('1111111');
    return ChoiceRes.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 204) {
    print('222222');
    return;
  } else {
    if (kDebugMode) {
      print('code = ${response.statusCode}');
      print('errMsg = ${response.body}');
    } else {
      throw Exception("invalid matching request");
    }
  }
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
