import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Translator',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("♀ Women Translator ♀"),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter your sentence",
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () async {
                // showDialog(context: context, barrierDismissible: false,builder: (context) => LoadingWindow());
                BuildContext dialogContext;
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    dialogContext = context;
                    return LoadingWindow(
                      context: dialogContext,
                    );
                  },
                ).then((value) async {
                  print(value);
                  BuildContext dialogContext2;
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        dialogContext2 = context;
                        return ResultWindow(
                          context: dialogContext2,
                        );
                      });
                });
                //
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.pink.shade50,
                backgroundColor: Colors.pink,
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
                child: Text(
                  "Translate",
                  style: TextStyle(fontSize: 34),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingWindow extends StatefulWidget {
  const LoadingWindow({Key? key, BuildContext? context}) : super(key: key);

  @override
  State<LoadingWindow> createState() => _LoadingWindowState();
}

class _LoadingWindowState extends State<LoadingWindow> {
  late Timer timer;
  String text = "Loading";
  int counter = 0;
  List<String> texts = ["Loading", "Loading.", "Loading..", "Loading..."];

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (Timer t) => {
              setState(() {
                text = texts[counter];
                counter++;
                if (counter > 3) {
                  counter = 0;
                }
              })
            });
    killWindowInSeconds(5, context);
  }

  void killWindowInSeconds(int seconds, BuildContext context) async {
    await Future.delayed(Duration(seconds: seconds));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
      ),
      content: Container(
        child: const SpinKitPumpingHeart(
          size: 140,
          color: Colors.pinkAccent,
        ),
        padding: EdgeInsets.all(24.0),
      ),
    );
  }
}

class ResultWindow extends StatefulWidget {
  const ResultWindow({Key? key, BuildContext? context}) : super(key: key);

  @override
  State<ResultWindow> createState() => _ResultWindowState();
}

class _ResultWindowState extends State<ResultWindow> {
  List<String> responses = ["how am i supposed to know that shit", "we coudn't translate this even if we tried", "The fuck?", "You better hope she's in a good mood"];
  int index = 0;
  final _random = new Random();
  @override
  void initState(){
    index = _random.nextInt(responses.length);
  }

  @override
  Widget build(BuildContext context) {
    index = _random.nextInt(responses.length);
    return AlertDialog(
      title: const Text(
        "Results",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
      ),
      actions: [
        TextButton(onPressed: (){
          if(!mounted) return;
          Navigator.of(context).pop();
        }, child: const Text("Close"))
      ],
      content: Container(
        padding: EdgeInsets.all(24.0),
        height: 150,

        // child: Text(responses[index]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("The translation reads", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Container(
              child: Text(responses[index]),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red)
              ),
            )
          ],
        )

      ),
    );
  }
}
