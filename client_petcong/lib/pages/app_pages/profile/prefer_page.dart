import 'package:flutter/material.dart';
import 'package:petcong/controller/signup_controller.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'gender_page.dart';
import 'pet_name_page.dart';

class PreferPage extends StatefulWidget {
  final double progress;

  const PreferPage({Key? key, required this.progress}) : super(key: key);

  @override
  PreferPageState createState() => PreferPageState();
}

class PreferPageState extends State<PreferPage> {
  final SignupController signupController = Get.put(SignupController());
  String _prefer = '';
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
                  onPressed: () => Get.off(const GenderPage(progress: 0.3)),
                ),
              ),
              const SizedBox(height: 5.0),
              const Center(
                  child: Text('추천 상대!',
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
                    isFilled: _prefer == 'FEMALE',
                    buttonText: '여자!',
                    onPressed: () {
                      setState(() {
                        _prefer = 'FEMALE';
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
                    isFilled: _prefer == 'MALE',
                    buttonText: '남자!',
                    onPressed: () {
                      setState(() {
                        _prefer = 'MALE';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _prefer == 'BOTH',
                    buttonText: '상관 없어요!',
                    onPressed: () {
                      setState(() {
                        _prefer = 'BOTH';
                        _isButtonDisabled = false;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 70.0),
              ContinueButton(
                isFilled: !_isButtonDisabled,
                buttonText: 'CONTINUE',
                onPressed: !_isButtonDisabled
                    ? () {
                        SignupController.to.addPreference(_prefer);
                        Get.to(
                            PetNamePage(
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
