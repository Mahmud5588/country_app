import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  final TextEditingController _answerController = TextEditingController();
  late Timer _timer;
  int _timeLeft = 60;
  int _score = 0;
  List<dynamic> _countries = [];
  dynamic _currentQuestion;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allCountryNotifierProvider.notifier).getCountry();
    });
  }

  void _startQuiz(List<dynamic> countries) {
    setState(() {
      _countries = countries;
      _nextQuestion();
      _startTimer();
    });
  }

  void _nextQuestion() {
    if (_countries.isNotEmpty) {
      setState(() {
        _currentQuestion = _countries[Random().nextInt(_countries.length)];
        _isCorrect = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer.cancel();
        _showResultDialog();
      }
    });
  }

  void _checkAnswer() {
    if (_answerController.text.trim().toLowerCase() ==
        _currentQuestion.capital.first.toLowerCase()) {
      setState(() {
        _score++;
        _isCorrect = true;
      });
    }
    _answerController.clear();
    Future.delayed(const Duration(milliseconds: 800), _nextQuestion);
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeInDown(
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Quiz Finished!", textAlign: TextAlign.center),
          content: Text("Your Score: $_score",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20)),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    if (state is AllCountryLoadedState && _countries.isEmpty) {
      _startQuiz(state.countries);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Country Quiz"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: state is AllCountryLoadingState
          ? const Center(child: CircularProgressIndicator())
          : state is AllCountryLoadedState
              ? FadeIn(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("⏳ Time Left: $_timeLeft sec",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        const SizedBox(height: 20),
                        BounceInDown(
                          child: Text(
                            "What is the capital of ${_currentQuestion?.name.common}?",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _answerController,
                          decoration: InputDecoration(
                            hintText: "Enter capital",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                          ),
                          child: const Text("Submit",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        FadeIn(
                          child: Text(
                            "⭐ Score: $_score",
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text("Failed to load countries",
                      style: TextStyle(fontSize: 18, color: Colors.red))),
    );
  }
}
