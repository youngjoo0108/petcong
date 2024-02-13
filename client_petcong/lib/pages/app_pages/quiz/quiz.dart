class Quiz {
  String question;
  String answer;

  Quiz({required this.question, required this.answer});
}

class QuizManager {
  final List<Quiz> _quizList = [];

  void addQuiz(Quiz quiz) {
    _quizList.add(quiz);
  }

  Quiz getQuiz(int index) {
    return _quizList[index];
  }

  int getQuizCount() {
    return _quizList.length;
  }
}
