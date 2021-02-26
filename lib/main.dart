import 'package:chrismas_tree_app/pages/manage_bluetooth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';



 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrismass Tree App',
      home: StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        builder: (_,state){

          if(state.data == BluetoothState.on)
            return ManageBluetoothPage();
          return Container();

        },
      )
    );
  }
}