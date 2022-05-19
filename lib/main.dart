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
  final wordList = words.words;
  final keyboardList = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Backspace']
  ];
  double sizeFactor = 0.6;

  var answer = '';
  bool isGameWin = false;
  var goContents = [
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
    [
      ['', ''],
      ['', ''],
      ['', ''],
      ['', ''],
      ['', '']
    ],
  ];
  int floor = 0;
  int myIndex = 0;
  var keyMap = <String, String>{};

  reset() {
    answer = '';
    isGameWin = false;
    goContents = [
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
      [
        ['', ''],
        ['', ''],
        ['', ''],
        ['', ''],
        ['', '']
      ],
    ];
    floor = 0;
    myIndex = 0;
    keyMap = <String, String>{};
  }

  renderGo() {
    goComponent(idx, val) {
      return Container(
        height: 60 * sizeFactor,
        width: 60 * sizeFactor,
        padding: EdgeInsets.all(5 * sizeFactor),
        margin: EdgeInsets.all(5 * sizeFactor),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2 * sizeFactor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            color: (() {
              if (idx < floor) {
                switch (val[1]) {
                  case 'Ans':
                    return Colors.green;
                  case 'AWP':
                    return Colors.amber;
                  case 'NIA':
                    return Colors.grey[600];
                }
              } else {
                return Colors.white;
              }
            }())),
        child: Text(
          val[0],
          style: TextStyle(fontSize: 40 * sizeFactor),
          textAlign: TextAlign.center,
        ),
      );
    }

    return goContents.asMap().entries.map((entry) {
      int idx = entry.key;
      var x = entry.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: x.asMap().entries.map((entry) {
          var val = entry.value;
          return Container(child: goComponent(idx, val));
        }).toList(),
      );
    }).toList();
  }

  renderKeyboard() {
    keyComponent(val) {
      var keyState = keyMap.containsKey(val) ? keyMap[val] : "";
      return SizedBox(
        child: InkWell(
          child: Container(
            height: 60 * sizeFactor,
            padding: EdgeInsets.all(15 * sizeFactor),
            margin: EdgeInsets.all(5 * sizeFactor),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: (() {
                  switch (keyState) {
                    case 'Ans':
                      //Answer
                      return Colors.green;
                    case 'AWP':
                      //At Wrong Place
                      return Colors.amber;
                    case 'NIA':
                      //Not In Answer
                      return Colors.grey[600];
                    case '':
                      return Colors.grey[400];
                  }
                }())),
            child: Center(
                child: (val == "Backspace")
                    ? Icon(
                        Icons.backspace_outlined,
                        size: 15 * sizeFactor,
                      )
                    : Text(
                        val,
                        style: TextStyle(fontSize: 20 * sizeFactor),
                        textAlign: TextAlign.center,
                      )),
          ),
          onTap: () {
            switch (val) {
              case 'ENTER':
                var guess = '';
                for (var elem in goContents[floor]) {
                  guess += elem[0];
                }

                if (guess == answer) {
                  setState(() {
                    isGameWin = true;
                  });
                }

                if (goContents[floor][4][0] == '') {
                  //NoEnoughLetters
                } else {
                  setState(() {
                    for (int i = 0; i < 5; i++) {
                      var val = goContents[floor][i];
                      if (answer[i] == val[0]) {
                        keyMap[val[0]] = 'Ans';
                        val[1] = 'Ans';
                      } else if (answer.split('').contains(val[0])) {
                        if (!keyMap.containsKey(val[0])) keyMap[val[0]] = 'AWP';
                        val[1] = 'AWP';
                      } else {
                        keyMap[val[0]] = 'NIA';
                        val[1] = 'NIA';
                      }
                    }
                    floor++;
                    myIndex = 0;
                  });
                }
                break;
              case 'Backspace':
                setState(() {
                  goContents[floor][myIndex - 1][0] = '';
                  myIndex = max(0, myIndex - 1);
                });
                break;
              default:
                setState(() {
                  goContents[floor][min(4, myIndex)][0] = val;
                  myIndex = min(5, myIndex + 1);
                });
                break;
            }
          },
        ),
      );
    }

    return keyboardList
        .map(
          (x) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: x.map((val) {
              return Container(child: keyComponent(val));
            }).toList(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var isGameOver = (isGameWin | (floor > 5));
    if (answer == "") {
      var rnd = Random().nextInt(wordList.length);
      setState(() {
        answer = wordList[rnd].toUpperCase();
      });
    }

    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.all(10 * sizeFactor),
              padding: EdgeInsets.all(10 * sizeFactor),
              child: Column(
                children: [
                  if (isGameOver)
                    Column(
                      children: [
                        Text(isGameWin ? "Correct!!" : "Game Over",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40 * sizeFactor,
                            )),
                        Text('The answer was $answer'),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              reset();
                            });
                          },
                          child: const Text("RETRY"),
                        ),
                      ],
                    )
                ],
              ),
            ),
            SizedBox(
              child: Center(
                child: Column(
                  children: renderGo(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10 * sizeFactor),
              padding: EdgeInsets.all(10 * sizeFactor),
              child: Center(
                child: Column(
                  children: renderKeyboard(),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Fwordle'), centerTitle: true),
    ));
  }
}
