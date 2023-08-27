import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> board = [];
  List<Color> lsbgcPanel = []; // List of Panel Background Color
  List<Text> lstxtPanel = []; // List of Panel Text
  String turn = Random().nextInt(2) == 1 ? "O" : "X";
  String txtMessage = "";
  bool resultMsgVisibilty = false;
  bool isPlaying = true;
  int count = 0;

  _MyAppState() {
    for (int i = 0; i < 9; ++i) {
      board.add("");

      lsbgcPanel.add(Colors.blue[400]!);
      lstxtPanel.add(const Text(""));
    }
  }

  void validate() {
    bool flag = false;
    List<int> panelIndex = [];

    for (int i = 0; i < 3; ++i) {
      if (board[i * 3] != "" &&
          board[i * 3 + 1] != "" &&
          board[i * 3 + 2] != "" &&
          board[i * 3] == board[i * 3 + 1] &&
          board[i * 3] == board[i * 3 + 2]) {
        flag = true;
        panelIndex.add(i * 3);
        panelIndex.add(i * 3 + 1);
        panelIndex.add(i * 3 + 2);

        break;
      }
    }

    if (flag == false) {
      for (int i = 0; i < 3; ++i) {
        if (board[i] != "" &&
            board[i + 3] != "" &&
            board[i + 6] != "" &&
            board[i] == board[i + 3] &&
            board[i] == board[i + 6]) {
          flag = true;
          panelIndex.add(i);
          panelIndex.add(i + 3);
          panelIndex.add(i + 6);

          break;
        }
      }
    }

    if (flag == false) {
      if (board[0] != "" &&
          board[4] != "" &&
          board[8] != "" &&
          board[0] == board[4] &&
          board[0] == board[8]) {
        flag = true;
        panelIndex.add(0);
        panelIndex.add(4);
        panelIndex.add(8);
      }
    }

    if (flag == false) {
      if (board[2] != "" &&
          board[4] != "" &&
          board[6] != "" &&
          board[2] == board[4] &&
          board[2] == board[6]) {
        flag = true;
        panelIndex.add(2);
        panelIndex.add(4);
        panelIndex.add(6);
      }
    }

    if (flag == true || count == 9) {
      setState(() {
        if (flag == true) {
          for (int i = 0; i < 3; ++i) {
            lsbgcPanel[panelIndex[i]] = Colors.yellow[200]!;
          }

          txtMessage = "$turn WIN";
        } else if (count == 9) {
          txtMessage = "DRAW";
        }

        isPlaying = false;
        resultMsgVisibilty = true;
      });
    }
  }

  void reset() {
    setState(() {
      turn = Random().nextInt(2) == 1 ? "O" : "X";
      txtMessage = "";
      isPlaying = true;
      count = 0;
      resultMsgVisibilty = false;

      for (int i = 0; i < 9; ++i) {
        board[i] = "";
        lsbgcPanel[i] = Colors.blue[400]!;
        lstxtPanel[i] = const Text("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double panelSize = screenWidth / 3;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: () {
                reset();
              },
              child: Text(
                "New Game",
                style: TextStyle(
                  color: Colors.yellow[200],
                ),
              ),
            )
          ],
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Tic",
                  style: TextStyle(
                    fontSize: screenWidth / 100 * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[200],
                  ),
                ),
                TextSpan(
                  text: "Tac",
                  style: TextStyle(
                    fontSize: screenWidth / 100 * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[200],
                  ),
                ),
                TextSpan(
                  text: "Toe",
                  style: TextStyle(
                    fontSize: screenWidth / 100 * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[200],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenWidth / 100 * 15,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      color: Colors.grey[350],
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Turn: ",
                              style: TextStyle(
                                fontSize: screenWidth / 100 * 5,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: turn,
                              style: TextStyle(
                                fontSize: screenWidth / 100 * 5,
                                fontWeight: FontWeight.bold,
                                color: turn == "X" ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 3; ++i)
                  Row(children: [
                    for (int j = 0, k = i * 3; j < 3; ++j, ++k)
                      Container(
                        color: lsbgcPanel[k],
                        height: panelSize,
                        width: panelSize - 3,
                        margin: const EdgeInsets.all(1.0),
                        child: TextButton(
                            onPressed: (board[k] != "" || isPlaying == false)
                                ? null
                                : () {
                                    setState(() {
                                      count = count + 1;
                                      board[k] = turn;

                                      lstxtPanel[k] = Text(
                                        turn,
                                        style: TextStyle(
                                          fontSize: screenWidth / 100 * 25,
                                          color: turn == "X"
                                              ? Colors.red[200]
                                              : Colors.green[200],
                                        ),
                                      );
                                    });

                                    validate();

                                    if (turn == "X") {
                                      turn = "O";
                                    } else {
                                      turn = "X";
                                    }
                                  },
                            child: lstxtPanel[k]),
                      ),
                  ])
              ],
            ),
            Visibility(
              visible: resultMsgVisibilty,
              child: SizedBox(
                width: screenWidth,
                height: screenWidth,
                child: Center(
                  child: Container(
                    width: screenWidth,
                    height: screenWidth / 100 * 35,
                    alignment: Alignment.center,
                    color: Colors.blue[100],
                    child: Column(
                      children: [
                        Text(
                          txtMessage,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            reset();
                          },
                          child: Text(
                            "Play again",
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
