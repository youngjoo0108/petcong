import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcong/controller/user_controller.dart';
import 'package:petcong/models/choice_res.dart';
import 'package:petcong/models/user_model.dart';
import 'package:get/get.dart';

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

  Future<dynamic> postMatching(int targetUserId) async {
    String endpoint = '$serverUrl/matchings/choice';
    final response = await http.post(Uri.parse(endpoint),
        headers: reqHeaders, body: jsonEncode({'partnerUserId': targetUserId}));

    if (response.statusCode == 200) {
      return ChoiceRes.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 204) {
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
}
