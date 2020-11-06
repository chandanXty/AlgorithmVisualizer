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
  String mCurrentSortAlgo='bubble';
  static int duration=1500;
  StreamController<List<int>> _streamController;
  Stream<List<int>> _stream;


// Duration function used in Quicksort Future
  Duration _getDuration() {
    return Duration(microseconds: duration);
  }

  _randomize(){
    numbers=[];
    for (int i=0;i< _samplesize;i++){
      numbers.add(Random().nextInt(_samplesize));
    }

    _streamController.add(numbers);
  }

  mBubblesort() async{
    /////////////Bubble sort Algorithm


    for (int i = 0; i < numbers.length; i++)
      for (int j = 0; j < numbers.length - i - 1; j++) {
        if (numbers[j] > numbers[j + 1]) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 1));

        _streamController.add(numbers);

      }
  }

  mInsertionsort() async{

    ////////////////InsertionSort Algorithm



    for (int i=1;i<_samplesize;i++)
          {
               for (int j=i;j>=1;j--)
                 {
                     if (numbers[j]>=numbers[j-1]) break;
                     int temp=numbers[j];
                     numbers[j]=numbers[j-1];
                     numbers[j-1]=temp;

                 }
               await Future.delayed(Duration(microseconds: 1));

               _streamController.add(numbers);
          }

  }

  mSelectionsort() async{
    /////////////////Selection sort Algorithm
       for (int i=0;i<_samplesize;i++)
              {
                   int min=-1,ind=i;

                   for (int j=i;j<_samplesize;j++)
                     {
                         if (numbers[j]<min ||min<0)
                          { min=numbers[j];ind=j;}
                     }
                  int temp=numbers[ind];
                   numbers[ind]=numbers[i];
                   numbers[i]=temp;

                   await Future.delayed(Duration(microseconds: 1));

                   _streamController.add(numbers);
              }


  }

   // comparator function used by quicksort
  cf(int a, int b) {
    if (a < b) {
      return -1;
    } else if (a > b) {
      return 1;
    } else {
      return 0;
    }
  }



  ////////////////////Quick sort Algorithm
  mQuicksort(int leftIndex,int rightIndex) async{

    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = numbers[p];
      numbers[p] = numbers[right];
      numbers[right] = temp;
      await Future.delayed(_getDuration(), () {});

      _streamController.add(numbers);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(numbers[i], numbers[right]) <= 0) {
          var temp = numbers[i];
          numbers[i] = numbers[cursor];
          numbers[cursor] = temp;
          cursor++;

          await Future.delayed(_getDuration(), () {});

          _streamController.add(numbers);
        }
      }

      temp = numbers[right];
      numbers[right] = numbers[cursor];
      numbers[cursor] = temp;

      await Future.delayed(_getDuration(), () {});

      _streamController.add(numbers);

      return cursor;
    }

    if (leftIndex < rightIndex) {
      int p = await _partition(leftIndex, rightIndex);

      await mQuicksort(leftIndex, p - 1);

      await mQuicksort(p + 1, rightIndex);
    }

  }




  ////////////////Merge Sort  Algorithm

  mMergesort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List leftList = new List(leftSize);
      List rightList = new List(rightSize);

      for (int i = 0; i < leftSize; i++) leftList[i] = numbers[leftIndex + i];
      for (int j = 0; j < rightSize; j++) rightList[j] = numbers[middleIndex + j + 1];

      int i = 0, j = 0;
      int k = leftIndex;

      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          numbers[k] = leftList[i];
          i++;
        } else {
          numbers[k] = rightList[j];
          j++;
        }

        await Future.delayed(_getDuration(), () {});
        _streamController.add(numbers);

        k++;
      }

      while (i < leftSize) {
        numbers[k] = leftList[i];
        i++;
        k++;

        await Future.delayed(_getDuration(), () {});
        _streamController.add(numbers);
      }

      while (j < rightSize) {
        numbers[k] = rightList[j];
        j++;
        k++;

        await Future.delayed(_getDuration(), () {});
        _streamController.add(numbers);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;

      await mMergesort(leftIndex, middleIndex);
      await mMergesort(middleIndex + 1, rightIndex);

      await Future.delayed(_getDuration(), () {});

      _streamController.add(numbers);

      await merge(leftIndex, middleIndex, rightIndex);
    }
  }


  ////////////////Heap Sort Algorithm

  mHeapsort() async {
    for (int i = numbers.length ~/ 2; i >= 0; i--) {
      await heapify(numbers,numbers.length, i);
      _streamController.add(numbers);
    }
    for (int i = numbers.length - 1; i >= 0; i--) {
      int temp = numbers[0];
      numbers[0] = numbers[i];
      numbers[i] = temp;
      await heapify(numbers, i, 0);
      _streamController.add(numbers);
    }
  }

  heapify(List<int> arr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;

    if (l < n && arr[l] > arr[largest]) largest = l;

    if (r < n && arr[r] > arr[largest]) largest = r;

    if (largest != i) {
      int temp = numbers[i];
      numbers[i] = numbers[largest];
      numbers[largest] = temp;
      heapify(arr, n, largest);
    }
    await Future.delayed(_getDuration());
  }


  _sort() async{


     // Here we are deciding which sorting to call based on currently deciding function by menu


       switch(mCurrentSortAlgo){
         case "bubble": mBubblesort();
                        break;
         case "insertion": mInsertionsort();
                           break;
         case "selection": mSelectionsort();
                           break;
         case "quick": mQuicksort(0,_samplesize.toInt()-1);
                       break;
         case "merge": mMergesort(0,_samplesize.toInt()-1);
                       break;
         case "heap": mHeapsort();
                      break;


       }

  }

  String _getTitle(){
    switch(mCurrentSortAlgo){
      case "bubble":
        return "Bubble Sort";
        break;
      case "heap":
        return "Heap Sort";
        break;
      case "selection":
        return "Selection Sort";
        break;
      case "insertion":
        return "Insertion Sort";
        break;
      case "quick":
        return "Quick Sort";
        break;
      case "merge":
        return "Merge Sort";
        break;


    }

  }

  _setsortAlgo (String type){
     setState(() {
       mCurrentSortAlgo=type;
     });
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

        title: Text(_getTitle()),
        backgroundColor: Color(0xFF0E4D64),
        actions: <Widget>[

          PopupMenuButton<String>(
            initialValue: mCurrentSortAlgo,
            itemBuilder: (ctx){
                return [
                  PopupMenuItem(
                    value:'bubble',
                    child: Text("Bubble Sort"),
                  ),
                  PopupMenuItem(
                    value:'insertion',
                    child: Text("Insertion Sort"),
                  ),
                  PopupMenuItem(
                    value:'selection',
                    child: Text("Selection Sort"),
                  ),
                  PopupMenuItem(
                    value:'quick',
                    child: Text("Quick Sort"),
                  ),
                  PopupMenuItem(
                    value:'merge',
                    child: Text("Merge Sort"),
                  ),
                  PopupMenuItem(
                    value:'heap',
                    child: Text("Heap Sort"),
                  ),

                ];
            },
            onSelected: (String value){

              _setsortAlgo(value);
            },
          )


        ],
      ),
      body: Container(
        child: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            int counter=0;
            return Row(                                 // this returns the bars with height using value in array
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
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
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
