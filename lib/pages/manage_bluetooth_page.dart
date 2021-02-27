import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ManageBluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Active Bluethoot Please...'),
            Icon(Icons.bluetooth_rounded),
          ],
        )
      ),
    );
  }
}

