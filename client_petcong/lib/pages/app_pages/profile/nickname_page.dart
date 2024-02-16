import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'birthday_page.dart';
import 'profile_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'package:petcong/controller/user_controller.dart';

class NicknamePage extends StatefulWidget {
  final double progress;

  const NicknamePage({Key? key, required this.progress}) : super(key: key);

  @override
  NicknamePageState createState() => NicknamePageState();
}

class NicknamePageState extends State<NicknamePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  double _progress = 0.1;
  String? _nickname;
  final UserController userController = Get.put(UserController());
  final SignupController signupController = Get.put(SignupController());
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
      });
    });
    _progress = widget.progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: _progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
            Color.fromARGB(255, 249, 113, 95),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainProfilePage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5.0),
            const Text('내 별명은?',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cafe24',
                )),
            const SizedBox(height: 30.0),
            SizedBox(
              width: 200, // 원하는 너비 설정
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _nickname = value;
                  });
                },
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                  fontFamily: 'Cafe24',
                ),
                decoration: const InputDecoration(
                  hintText: '별명을 입력하세요',
                  border: InputBorder.none,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 249, 113, 95)),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),
            ContinueButton(
              isFilled: !_isButtonDisabled,
              buttonText: 'CONTINUE',
              onPressed: !_isButtonDisabled
                  ? () {
                      // 'CONTINUE' 버튼을 누르면 UserController의 nickname을 업데이트하고, BirthdayPage로 이동합니다.
                      // userController.nickname = _controller.text.trim();
                      SignupController.to.addNickName(_nickname!);
                      Get.to(
                          BirthdayPage(
                            progress: widget.progress + 0.1,
                          ),
                          transition: Transition.noTransition);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
