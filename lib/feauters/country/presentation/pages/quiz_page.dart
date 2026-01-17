import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_provider.dart';
import 'package:country_app/feauters/country/presentation/manager/all_country_provider/all_country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
  List<dynamic> _quizCountries = [];
  dynamic _currentQuestion;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Eslatma: Ma'lumot allaqachon providerda bo'lishi mumkin, shuning uchun qayta fetch qilish shart emas agar state loaded bo'lsa
  }

  void _startQuiz(List<dynamic> allCountries) {
    // Faqat poytaxti bor mamlakatlarni olamiz
    final validCountries = allCountries.where((c) => c.capital.isNotEmpty).toList();
    if (validCountries.isEmpty) return;

    setState(() {
      _quizCountries = validCountries;
      _isPlaying = true;
      _timeLeft = 60;
      _score = 0;
    });
    _nextQuestion();
    _startTimer();
  }

  void _nextQuestion() {
    if (_quizCountries.isNotEmpty) {
      setState(() {
        _currentQuestion = _quizCountries[Random().nextInt(_quizCountries.length)];
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer.cancel();
        _showResultDialog();
      }
    });
  }

  void _checkAnswer() {
    if (_currentQuestion == null) return;
    
    final correctAnswer = _currentQuestion.capital.first.toString().toLowerCase();
    final userAnswer = _answerController.text.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
      setState(() => _score++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("To'g'ri! 🎉"), backgroundColor: Colors.green, duration: Duration(milliseconds: 500)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xato! Poytaxt: ${_currentQuestion.capital.first}"), backgroundColor: Colors.red, duration: Duration(milliseconds: 1000)),
      );
    }
    _answerController.clear();
    _nextQuestion();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("O'yin Tugadi!"),
        content: Text("Sizning natijangiz: $_score ta to'g'ri javob."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Chiqish"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allCountryNotifierProvider);

    if (!_isPlaying && state is AllCountryLoadedState) {
       // Avtomatik boshlash yoki tugma bilan boshlash mumkin.
       // UX uchun "Start" tugmasi yaxshiroq
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text("Poytaxtni Top", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: !_isPlaying 
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Boshlash"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                   if (state is AllCountryLoadedState) {
                     _startQuiz(state.countries);
                   } else {
                     ref.read(allCountryNotifierProvider.notifier).getCountry();
                   }
                },
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _timeLeft / 60,
                    backgroundColor: Colors.grey[300],
                    color: _timeLeft < 10 ? Colors.red : Colors.deepPurple,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                           if (_currentQuestion != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: _currentQuestion.flags.png,
                                height: 100,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            _currentQuestion?.name.common ?? "Yuklanmoqda...",
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "davlatining poytaxti qaysi?",
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: "Javobni kiriting...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.deepPurple),
                        onPressed: _checkAnswer,
                      ),
                    ),
                    onSubmitted: (_) => _checkAnswer(),
                  ),
                  const SizedBox(height: 40),
                  Text("Ball: $_score", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    if (_isPlaying) _timer.cancel();
    _answerController.dispose();
    super.dispose();
  }
}
