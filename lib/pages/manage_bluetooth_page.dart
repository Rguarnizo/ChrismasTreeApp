import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ManageBluetoothPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        title: Text('Active Bluetooth'),
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: _BuildDevices(),
      ),
    );
  }
}

class _BuildDevices extends StatelessWidget {
  const _BuildDevices({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));

    return StreamBuilder<List<BluetoothDevice>>(
      stream: Stream.periodic(Duration(seconds: 2)).asyncMap((_) => FlutterBlue.instance.connectedDevices),
      builder: (_, snapshot) => SingleChildScrollView(
          child: Column(
              children: snapshot.hasData
                  ? snapshot.data
                      .map((device) => ListTile(
                            title: Text(device.name),
                            subtitle: Text(device.id.toString()),
                            onTap: (){
                              
                            },
                          ))
                      .toList() 
                  : Container())),
    );
  }
}
