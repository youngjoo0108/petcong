import 'package:flutter/material.dart';
import 'birthday_page.dart';

class GenderPage extends StatefulWidget {
  final double progress;

  const GenderPage({Key? key, required this.progress}) : super(key: key);

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String _gender = '';
  double _progress = 2 / 10;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  void _increaseProgress() {
    setState(() {
      _progress += 1 / 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BirthdayPage(progress: 1 / 10),
            ),
          ),
        ),
        title: LinearProgressIndicator(value: _progress),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text('성별을 선택하세요', style: TextStyle(fontSize: 24.0)),
            ListTile(
              title: const Text('여자예요'),
              leading: Radio(
                value: '여자',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('남자예요'),
              leading: Radio(
                value: '남자',
                groupValue: _gender,
                onChanged: (String? value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _gender.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PetNamePage(progress: _progress + 1 / 10)),
                      );
                    },
              child: const Text('계속하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class PetNamePage extends StatefulWidget {
  final double progress;

  const PetNamePage({Key? key, required this.progress}) : super(key: key);

  @override
  _PetNamePageState createState() => _PetNamePageState();
}

class _PetNamePageState extends State<PetNamePage> {
  @override
  Widget build(BuildContext context) {
    // 여기에 PetNamePage의 구현을 추가하세요.
    return const Scaffold();
  }
}
