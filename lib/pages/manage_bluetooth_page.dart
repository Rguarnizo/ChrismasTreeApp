import 'package:flutter/material.dart';


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

