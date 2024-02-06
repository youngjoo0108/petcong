import 'package:flutter/material.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'package:get/get.dart';
import 'gender_page.dart';
import 'pet_name_page.dart';

class PreferPage extends StatefulWidget {
  final double progress;

  const PreferPage({Key? key, required this.progress}) : super(key: key);

  @override
  _PreferPageState createState() => _PreferPageState();
}

class _PreferPageState extends State<PreferPage> {
  String _prefer = '';
  double _progress = 0.0;
  bool _isButtonDisabled = true; // _isButtonDisabled 변수 선언

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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 32),
                  onPressed: () => Get.off(const GenderPage(progress: 3 / 12)),
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(
                  child: Text('추천 상대!', style: TextStyle(fontSize: 32.0))),
              const SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 240.0,
                  height: 50.0,
                  child: ContinueButton(
                    isFilled: _prefer == '선호1',
                    buttonText: '여자예요!',
                    onPressed: () {
                      setState(() {
                        _prefer = '선호1';
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
                    isFilled: _prefer == '선호2',
                    buttonText: '남자예요!',
                    onPressed: () {
                      setState(() {
                        _prefer = '선호2';
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
                    isFilled: _prefer == '선호3',
                    buttonText: '상관 없어요!',
                    onPressed: () {
                      setState(() {
                        _prefer = '선호3';
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
                        Get.to(PetNamePage(
                          progress: widget.progress + 1 / 12,
                        ));
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
