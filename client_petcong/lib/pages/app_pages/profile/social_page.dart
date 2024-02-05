import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/widgets/continue_button.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final _formKey = GlobalKey<FormState>();
  String? _kakaoTalkId;
  String? _instagramId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'KakaoTalk ID'),
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    (_instagramId == null || _instagramId!.isEmpty)) {
                  return 'Please enter at least one ID';
                }
                return null;
              },
              onSaved: (value) {
                _kakaoTalkId = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Instagram ID'),
              validator: (value) {
                if ((value == null || value.isEmpty) &&
                    (_kakaoTalkId == null || _kakaoTalkId!.isEmpty)) {
                  return 'Please enter at least one ID';
                }
                return null;
              },
              onSaved: (value) {
                _instagramId = value;
              },
            ),
            ContinueButton(
              isFilled: _kakaoTalkId != null && _kakaoTalkId!.isNotEmpty ||
                  _instagramId != null && _instagramId!.isNotEmpty,
              buttonText: 'CONTINUE',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print(
                      'KakaoTalk ID: $_kakaoTalkId, Instagram ID: $_instagramId');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
