import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'birthday_page.dart';
import 'prefer_page.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';

class GenderPage extends StatefulWidget {
  final double progress;

  const GenderPage({Key? key, required this.progress}) : super(key: key);

  @override
  GenderPageState createState() => GenderPageState();
}

class GenderPageState extends State<GenderPage> {
  final SignupController signupController = Get.put(SignupController());
  String _gender = '';
  double _progress = 0.0;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 32),
                  onPressed: () => Get.off(const BirthdayPage(progress: 0.2)),
                ),
              ),
              const SizedBox(height: 5.0),
              const Center(
                  child: Text('저는',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cafe24',
                      ))),
              const SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _gender == 'FEMALE',
                    buttonText: '여자예요!',
                    onPressed: () {
                      setState(() {
                        _gender = 'FEMALE';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _gender == 'MALE',
                    buttonText: '남자예요!',
                    onPressed: () {
                      setState(() {
                        _gender = 'MALE';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 90.0),
              ContinueButton(
                isFilled: !_isButtonDisabled,
                buttonText: 'CONTINUE',
                onPressed: !_isButtonDisabled
                    ? () {
                        SignupController.to.addGender(_gender);
                        Get.to(
                            PreferPage(
                              progress: widget.progress + 0.1,
                            ),
                            transition: Transition.noTransition);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
