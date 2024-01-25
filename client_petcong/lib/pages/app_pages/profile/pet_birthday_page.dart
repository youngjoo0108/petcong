import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petcong/pages/app_pages/profile/pet_name_page.dart';
import 'pet_gender_page.dart';
import 'package:petcong/widgets/continue_button.dart';

class PetBirthdayPage extends StatefulWidget {
  final String petName;
  final double progress;

  const PetBirthdayPage({
    Key? key,
    required this.petName,
    required this.progress,
  }) : super(key: key);

  @override
  _PetBirthdayPageState createState() => _PetBirthdayPageState();
}

class _PetBirthdayPageState extends State<PetBirthdayPage> {
  final _controller = TextEditingController();
  final _dateValidator = ValueNotifier<String?>('Initial value');
  final double _progress = 0.4;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.trim();
      _dateValidator.value =
          text.isEmpty ? 'Initial value' : _validateDate(text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dateValidator.dispose();
    super.dispose();
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return '생년월일을 입력해주세요';
    }
    const datePattern = r'^(\d{4})\/(\d{2})\/(\d{2})$';
    final match = RegExp(datePattern).firstMatch(value);
    if (match == null) {
      return '유효한 날짜 형식이 아닙니다 (YYYY/MM/DD)';
    }

    try {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      if (month < 1 || month > 12 || day < 1 || day > 31) {
        return '유효한 날짜가 아닙니다.';
      }
      if (day == 31 &&
          (month == 2 ||
              month == 4 ||
              month == 6 ||
              month == 9 ||
              month == 11)) {
        return '유효한 날짜가 아닙니다.';
      }
      if (month == 2 && day > 29) {
        return '유효한 날짜가 아닙니다.';
      }
      if (month == 2 && day == 29 && year % 4 != 0) {
        return '유효한 날짜가 아닙니다.';
      }
    } catch (e) {
      return '유효한 날짜가 아닙니다.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LinearProgressIndicator(
          value: _progress,
          valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 234, 64, 128)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 32),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PetNamePage(progress: 3 / 10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${widget.petName}의 생일은?',
                    style: const TextStyle(fontSize: 32.0),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 300, // 원하는 너비를 설정합니다.
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'YYYY/MM/DD',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: const TextStyle(fontSize: 20.0),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9/]')),
                        _DateInputFormatter(),
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ValueListenableBuilder<String?>(
                    valueListenable: _dateValidator,
                    builder: (context, value, child) {
                      return SizedBox(
                        child: ContinueButton(
                          isFilled: value ==
                              null, // value가 null인 경우에 버튼이 활성화되도록 수정합니다.
                          buttonText: 'Continue',
                          onPressed:
                              value == null // value가 null인 경우에 버튼이 눌리도록 수정합니다.
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PetGenderPage(
                                            petName: widget.petName,
                                            progress: widget.progress + 1 / 10,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    String newText = newValue.text.replaceAll('/', '');

    if (newText.length > 4) {
      newText = '${newText.substring(0, 4)}/${newText.substring(4)}';
    }
    if (newText.length > 7) {
      newText = '${newText.substring(0, 7)}/${newText.substring(7)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
