import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'social_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class IntroducePage extends StatefulWidget {
  final double progress;

  const IntroducePage({
    Key? key,
    required this.progress,
  }) : super(key: key);

  @override
  IntroducePageState createState() => IntroducePageState();
}

class IntroducePageState extends State<IntroducePage> {
  final _controller = TextEditingController();
  bool _isButtonDisabled = true;
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
    _controller.addListener(() {
      setState(() {
        _isButtonDisabled = _controller.text.trim().isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: LinearProgressIndicator(
            value: _progress,
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 249, 113, 95)),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 32),
                        onPressed: () => Get.back(result: _progress),
                      ),
                      TextButton(
                        child: const Text(
                          '건너뛰기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                            fontFamily: 'Cafe24',
                          ),
                        ),
                        onPressed: () {
                          Get.to(const SocialPage(
                            progress: 0.9,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text('자기 소개 해주세요!',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cafe24',
                    )),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 300.0,
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    readOnly: false,
                    onTap: () async {},
                    style: const TextStyle(
                      fontSize: 20.0,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Cafe24',
                    ),
                    decoration: const InputDecoration(
                      hintText: '자기 소개',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 249, 113, 95),
                            width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 249, 113, 95),
                            width: 1.0),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 50.0),
                ContinueButton(
                  isFilled: !_isButtonDisabled,
                  buttonText: 'CONTINUE',
                  onPressed: !_isButtonDisabled
                      ? () {
                          SignupController.to
                              .addDescription(_controller.value.text);
                          Get.to(
                              SocialPage(
                                progress: widget.progress + 0.1,
                              ),
                              transition: Transition.noTransition);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ));
  }
}
