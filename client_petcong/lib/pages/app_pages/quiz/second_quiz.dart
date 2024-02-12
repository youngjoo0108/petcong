import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcong/widgets/continue_button.dart';
import 'quiz.dart';

class SecondQuizPage extends StatelessWidget {
  final QuizManager quizManager = QuizManager();

  SecondQuizPage({super.key}) {
    quizManager.addQuiz(Quiz(question: '프랑스의 수도는?', answer: '파리'));
    quizManager.addQuiz(Quiz(question: '일본의 수도는?', answer: '도쿄'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Quiz')),
      body: ListView.builder(
        itemCount: quizManager.getQuizCount(),
        itemBuilder: (context, index) {
          Quiz quiz = quizManager.getQuiz(index);

          return ListTile(
            title: Text('퀴즈: ${quiz.question}'),
            subtitle: TextField(
              onChanged: (value) {
                if (value == quiz.answer) {
                  print('정답입니다!');
                } else {
                  print('오답입니다. 정답은 ${quiz.answer}입니다.');
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: ContinueButton(
        isFilled: true,
        buttonText: 'CONTINUE',
        onPressed: () {
          Get.to(ThirdQuizPage());
        },
      ),
    );
  }
}
