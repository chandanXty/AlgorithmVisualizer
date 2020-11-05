import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ''
          'Algorithm Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,


      ),
      home: MyHomePage(title: 'Algorithm Visualizer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<int> numbers=[];
  int _samplesize=500;

  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;


  _randomize(){
    numbers=[];
    for (int i=0;i< _samplesize;i++){
      numbers.add(Random().nextInt(_samplesize));
    }

    _streamController.add(numbers);
  }
  _sort() async{
    /////////////Bubble sort Algorithm


    for (int i = 0; i < numbers.length; i++)
      for (int j = 0; j < numbers.length - i - 1; j++) {
        if (numbers[j] > numbers[j + 1]) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
           await Future.delayed(Duration(microseconds: 1));
//        setState(() {});
        _streamController.add(numbers);

      }



  }
  @override
  void initState(){
    super.initState();
    _streamController= StreamController<List<int>>();
    _stream= _streamController.stream;
    _randomize();
  }


  @override
  Widget build(BuildContext context) {





    return Scaffold(
      appBar: AppBar(

        title: Text("Visualizer"),
      ),
      body: Container(
        child: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            int counter=0;
            return Row(
              children: numbers.map((int number)  {
                counter++;
                return CustomPaint(
                  painter: BarPainter(
                    width: MediaQuery.of(context).size.width/_samplesize,
                    value: number,
                    index: counter,

                  ),
                );
              }).toList()
            );
          }
        )
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(child: FlatButton(
             child: Text("Randomize"),
            onPressed: _randomize,
          ),),
          Expanded(child: FlatButton(
            child: Text("Sort"),
            onPressed: _sort,
          ))
        ],
      ),


    );
  }
}



class BarPainter extends CustomPainter{

  final double width;
  final int value;
  final int index;

  BarPainter({this.width,this.value,this.index});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint=Paint();

    if(this.value<500*.10) paint.color=Color(0xFFDEEDCF);
  else if (this.value<500*0.20) paint.color=Color(0xFFBFE1B0);
    else if (this.value<500*0.30) paint.color=Color(0xFF99D492);
    else if (this.value<500*0.40) paint.color=Color(0xFF74C67A);
    else if (this.value<500*0.50) paint.color=Color(0xFF568870);
    else if (this.value<500*0.60) paint.color=Color(0xFF39A96B);
    else if (this.value<500*0.70) paint.color=Color(0xFF109A6C);
    else if (this.value<500*0.80) paint.color=Color(0xFF188977);
    else if (this.value<500*0.90) paint.color=Color(0xFF137177);
    else paint.color=Color(0xFF0E4D64);


    paint.strokeWidth=width;
    paint.strokeCap= StrokeCap.round;


    canvas.drawLine(Offset(index*width,0),Offset(index*width, value.ceilToDouble()),paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
  }

}
