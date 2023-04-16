import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:backend_quiz/model/api_adapter.dart';
import 'package:backend_quiz/model/model_quiz.dart';
import 'package:backend_quiz/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Quiz> quizs = [];
  bool isLoading = false;

  _fetchQuizs() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse("http://localhost:8000/quiz/3"));
    // .get(Uri.parse("https://drf-quiz-test.herokuapp.com/quiz/3/"));
    if (response.statusCode == 200) {
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('failed to load api');
    }
  }
  // List<Quiz> quizs = [
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['aaa', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['aaaa', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  //   Quiz.fromMap({
  //     'title': 'test',
  //     'candidates': ['aaaa', 'b', 'c', 'd'],
  //     'answer': 0
  //   }),
  // ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('My Quiz APP'),
            backgroundColor: Colors.deepPurple,
            leading: Container(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/quiz.jpeg',
                  width: width * 0.8,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.024),
              ),
              Text(
                '플러터 퀴즈 앱',
                style: TextStyle(
                    fontSize: width * 0.065, fontWeight: FontWeight.bold),
              ),
              Text(
                '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              _buildStep(width, "1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요."),
              _buildStep(width, "2. 동이천재"),
              _buildStep(width, "3. 승기바보"),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              Container(
                padding: EdgeInsets.only(bottom: width * 0.036),
                child: Center(
                  child: ButtonTheme(
                    minWidth: width * 0.8,
                    height: height * 0.05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                        child: Text(
                          '지금 퀴즈 풀기',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              // content: ))

                              // _scaffoldKey.currentState.showSnackBar(
                              // SnackBar(
                              content: Row(
                                children: <Widget>[
                                  CircularProgressIndicator(),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.024)),
                                  Text("로딩 중..."),
                                ],
                              ),
                            ),
                          );
                          _fetchQuizs().whenComplete(() {
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  quizs: quizs,
                                ),
                              ),
                            );
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          width * 0.048, width * 0.024, width * 0.048, width * 0.024),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Icon(
          Icons.check_box,
          size: width * 0.04,
        ),
        Padding(
          padding: EdgeInsets.only(right: width * 0.024),
        ),
        Text(title)
      ]),
    );
  }
}
