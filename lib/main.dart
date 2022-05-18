import 'package:flutter/material.dart';
import "dart:math";

import 'words.dart' as words;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var msgController = TextEditingController();

  static const wordList = words.words;
  var answer = '';
  bool isGameWin = false;
  var goContents = [
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
    ['', '', '', '', ''],
  ];
  int floor = 0;
  String inputText = '';

  reset() {
    answer = '';
    isGameWin = false;
    goContents = [
      ['', '', '', '', ''],
      ['', '', '', '', ''],
      ['', '', '', '', ''],
      ['', '', '', '', ''],
      ['', '', '', '', ''],
      ['', '', '', '', ''],
    ];
    floor = 0;
    inputText = '';
  }

  renderKeyboard() {
    return goContents
        .map(
          (x) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: x.asMap().entries.map((entry) {
              int idx = entry.key;
              String val = entry.value;
              return Container(child: goComponent(idx, val));
            }).toList(),
          ),
        )
        .toList();
  }

  goComponent(idx, val) {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: (() {
            if (val == answer[idx]) {
              return Colors.green;
            } else if (answer.split('').contains(val)) {
              return Colors.amber;
            } else {
              if (val == "") {
                return Colors.white;
              } else {
                return Colors.grey;
              }
            }
          }())),
      child: Text(
        val,
        style: const TextStyle(fontSize: 40),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<AlertDialog> alert() async {
    return AlertDialog(
      title: const Text('Error'),
      content: const SingleChildScrollView(
        child: Text(
          'Error message',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var isWordFive = (inputText.length != 5);
    var isGameOver = (isGameWin | (floor > 5));
    if (answer == "") {
      var rnd = Random().nextInt(wordList.length);
      setState(() {
        answer = wordList[rnd];
      });
    }

    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    if (isGameOver)
                      Column(
                        children: [
                          Text(isGameWin ? "Correct!!" : "Game Over",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 41,
                              )),
                          Text('The answer was $answer'),
                          ElevatedButton(
                              onPressed: () {
                                msgController.clear();
                                setState(() {
                                  reset();
                                });
                              },
                              child: const Text("retry"),
                          ),],
                      )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    children: renderKeyboard(),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 400,
                child: Center(
                  child: Row(
                    children: [
                      Flexible(
                        child: Center(
                          child: TextField(
                            controller: msgController,
                            onChanged: (text) {
                              setState(() {
                                inputText = text;
                              });
                            },
                            decoration: const InputDecoration(
                              // labelText: '텍스트 입력',
                              hintText: 'Geuss the answer',
                              border: OutlineInputBorder(), //외곽선
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: OutlinedButton(
                          onPressed: (isWordFive | isGameOver)
                              ? null
                              : () {
                                  msgController.clear();
                                  List<String> listedWord = inputText.split('');
                                  setState(() {
                                    goContents[floor] = listedWord;
                                    floor++;
                                    if (answer == inputText) {
                                      isGameWin = true;
                                    }
                                  });
                                },
                          child: const Text("Submit"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(title: const Text('Fwordle'), centerTitle: true),
    ));
  }
}
