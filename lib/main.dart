//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

//La classe principale lancée en premier
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Splash Screen',
      home: MySplash(),
    );
  }
}

//Le splash screen appelé par la classe principale
class MySplash extends StatelessWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: App(),
      title: Text(
        'Converter',
        textScaleFactor: 2,
      ),
      //image: Image.network('https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}

//Création de l'app avec state
class App extends StatefulWidget {
  //création d'un state qui sera définie dans une autre class
  MyAppState createState() => MyAppState();
}

//Création du state utilisé dans App
class MyAppState extends State<App> {
  double _numberForm = 0;
  double _result = 0;
  String _resultMessage = '';
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];
  String? _startMeasures;
  String? _convertedMeasures;

  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };
  @override
  /*
  void initState(){
    _numberForm = 0;
    super.initState();
  }*/
  Widget build(BuildContext context) {
    final TextStyle inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );

    final TextStyle dropdownStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );

    final labelStyle = TextStyle(
      fontSize: 20,
      color: Colors.grey[700],
    );

    return MaterialApp(
      title: 'Converter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Converter'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Insert the measure to be converted',
                    ),
                    //Fonction appellée à chanque fois que le texte est changé
                    onChanged: (text) {
                      var rv = double.tryParse(text);
                      if (rv != null) {
                        setState(() {
                          _numberForm = rv;
                        });
                      }
                    },
                    style: inputStyle,
                  ),
                  //Text((_numberForm == null)? '' : _numberForm.toString()),
                  SizedBox(
                    height: 50,
                  ),
                  //FROM
                  Row(
                    children: [
                      Text(
                        'From',
                        style: labelStyle,
                      ),
                      SizedBox(width: 20),
                      DropdownButton<String>(
                        //isExpanded: true,
                        style: dropdownStyle,
                        items: _measures.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _startMeasures = value;
                          });
                        },
                        value: _startMeasures,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: Text('Invert'),
                      onPressed: () {
                        invertSelection();
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  //TO
                  Row(
                    children: [
                      Text(
                        'To',
                        style: labelStyle,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      DropdownButton<String>(
                        //isExpanded: true,
                        style: dropdownStyle,
                        items: _measures.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _convertedMeasures = value;
                          });
                        },
                        value: _convertedMeasures,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    _resultMessage,
                    style: labelStyle,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  //CONVERT BUTTON
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: ElevatedButton(
                      child: Text('Convert', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        if (_startMeasures == null ||
                            _convertedMeasures == null ||
                            _numberForm == 0) {
                          return;
                        } else {
                          convert(
                              _numberForm, _startMeasures, _convertedMeasures);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void convert(double value, String? from, String? to) {
    int? nFrom = _measuresMap[from];
    int? nTo = _measuresMap[to];
    var multiplier = _formulas[nFrom.toString()][nTo];

    if (multiplier == 0) {
      _resultMessage = 'This conversion cannot be performed';
    } else {
      _result = value * multiplier;
      _resultMessage = '${_result} $_convertedMeasures';
    }

    setState(() {
      _resultMessage = _resultMessage;
    });
  }

  void invertSelection() {
    String? intermediate;
    intermediate = _startMeasures;
    _startMeasures = _convertedMeasures;
    _convertedMeasures = intermediate;
    setState(() {
      _startMeasures = _startMeasures;
      _convertedMeasures = _convertedMeasures;
    });
  }
}
