import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrismass Tree App',
      home: Scaffold(
        body: Center(
          child: Container(
            child: CircleColorPicker(
              onChanged: (value) => print('R: ${value.red}  G: ${value.green}  B: ${value.blue}  '),
            ),
          ),
        ),
      )
    );
  }
}