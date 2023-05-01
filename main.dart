import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double x = 0;
  double y = 0;
  double eyex = 0;
  double eyey = 0;
  getX(details) {
    if (details.globalPosition.dy > MediaQuery.of(context).size.height / 2) {
      setState(() {
        x = (-details.globalPosition.dy +
                MediaQuery.of(context).size.height / 2) /
            1000;
        eyex = (details.globalPosition.dy -
                MediaQuery.of(context).size.height / 2) /
            MediaQuery.of(context).size.height *
            2;
      });
    } else {
      setState(() {
        x = (MediaQuery.of(context).size.height -
                details.globalPosition.dy -
                MediaQuery.of(context).size.height / 2) /
            1000;
        eyex = -(MediaQuery.of(context).size.height -
                details.globalPosition.dy -
                MediaQuery.of(context).size.height / 2) /
            MediaQuery.of(context).size.height *
            2;
      });
    }
  }

  getY(details) {
    if (details.globalPosition.dx > MediaQuery.of(context).size.width / 2) {
      setState(() {
        y = (-details.globalPosition.dx +
                MediaQuery.of(context).size.width / 2) /
            1000;
        eyey = (details.globalPosition.dx -
                MediaQuery.of(context).size.width / 2) /
            MediaQuery.of(context).size.width *
            2;
      });
    } else {
      setState(() {
        y = (MediaQuery.of(context).size.width -
                details.globalPosition.dx -
                MediaQuery.of(context).size.width / 2) /
            1000;
        eyey = -(MediaQuery.of(context).size.width -
                details.globalPosition.dx -
                MediaQuery.of(context).size.width / 2) /
            MediaQuery.of(context).size.width *
            2;
      });
    }
  }

  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 10), vsync: this);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            print(details.globalPosition);
            getX(details);
            getY(details);
          },
          onPanEnd: (details) => setState(() {
            x = 0;
            y = 0;
            eyex = 0;
            eyey = 0;
          }),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 18, 18, 18),
            child: Center(
              child: TweenAnimationBuilder(
                duration: Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                tween: Tween<double>(begin: 0, end: x),
                builder: (context, x, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(-x)
                      ..multiply(Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateY(y)),
                    alignment: FractionalOffset.center,
                    child: Container(
                      height: 350,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color.fromARGB(255, 240, 196, 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getEye(),
                          const SizedBox(width: 10),
                          getEye(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getEye() {
    return Container(
      width: 70,
      height: 70,
      alignment: Alignment(eyey, eyex),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.2),
              offset: Offset.zero,
              spreadRadius: -12,
            )
          ]),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.black,
        ),
      ),
    );
  }
}
