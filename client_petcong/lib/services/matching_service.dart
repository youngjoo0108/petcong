import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:get/get.dart';
import 'package:petcong/models/profile_model.dart';

class MatchingService extends GetxController {
  final bool testing = true;

  // User? currentUser = UserController.currentUser;
  // String idTokenString = currentUser?.getIdToken().toString() ?? "";
  User? currentUser;
  String? idTokenString;
  final String serverUrl = 'https://i10a603.p.ssafy.io';
  Map<String, String>? reqHeaders;

  @override
  void initState() {
    currentUser = UserController.currentUser;
    idTokenString = currentUser?.getIdToken().toString() ?? "";
    reqHeaders = {'tester': 'A603'};
  }

  Future<dynamic> postMatching(String targetUid) async {
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
// import 'package:petcong/controller/user_controller.dart';
// import 'package:petcong/services/user_service.dart';
// import 'package:http/http.dart' as http;

    const bool testing = true;

    User? currentUser = UserController.currentUser;
    String idTokenString = currentUser?.getIdToken().toString() ?? "";
    // Map<String, String> reqHeaders = checkTesting();

// POST /matchings/choice
    Future<Map<String, String>?> postChoice(String partnerUserId) async {
      final response = await http.post(Uri.parse('$serverUrl/matchings/choice'),
          headers: reqHeaders, body: jsonEncode({"partnerId": partnerUserId}));

      if (response.statusCode == 200) {
        // matching 성공 start webrtc
        if (kDebugMode) print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else if (response.statusCode == 204) {
        // request 성공, matching pending : do nothing
      } else {
        throw Exception("postChoice request failed");
      }
      return null;
    }

// GET /matchings/profile
    Future<ProfileModel> getProfile() async {
      final response = await http.get(Uri.parse('$serverUrl/matchings/profile'),
          headers: reqHeaders);

      if (response.statusCode == 200) {
        if (kDebugMode) print(jsonDecode(response.body));
        return ProfileModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("getProfile request failed");
      }
    }
  }
}
