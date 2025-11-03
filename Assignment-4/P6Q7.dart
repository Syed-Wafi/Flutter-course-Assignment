class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  Question(this.questionText, this.options, this.correctAnswerIndex);

  bool isCorrect(int userChoice) {
    return userChoice == correctAnswerIndex;
  }
}

class Quiz {
  List<Question> questions;
  int score = 0;

  Quiz(this.questions);

  void start() {
    for (int i = 0; i < questions.length; i++) {
      var q = questions[i];
      print('\nQ${i + 1}: ${q.questionText}');
      for (int j = 0; j < q.options.length; j++) {
        print('${j + 1}. ${q.options[j]}');
      }


      int userAnswer = (i == 0) ? 1 : (i == 1) ? 2 : 3;
      print('Your answer: $userAnswer');

      if (q.isCorrect(userAnswer - 1)) {
        print('✅ Correct!');
        score++;
      } else {
        print('❌ Wrong!');
      }
    }

    print('\nYour final score: $score / ${questions.length}');
  }
}

void main() {
  List<Question> questions = [
    Question('What is the capital of Bangladesh?', ['Dhaka', 'Chittagong', 'Khulna'], 0),
    Question('Which language is used for Flutter?', ['Python', 'Dart', 'Java'], 1),
    Question('Which planet is known as the Red Planet?', ['Earth', 'Mars', 'Venus'], 1),
  ];

  Quiz quiz = Quiz(questions);
  quiz.start();
}
