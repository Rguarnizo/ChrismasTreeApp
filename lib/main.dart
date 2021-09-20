import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _currentColor = Colors.blue;
  final _controller = CircleColorPickerController(
    initialColor: Colors.blue,
  );

  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        isDiscovering = true;
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else
          results.add(r);
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: isDiscovering? Text("Discovering"): ListView.builder(
        itemBuilder: (context, index) {
          BluetoothDiscoveryResult result = results[index];
          final device = result.device;
          final address = device.address;

          return ListTile(
            title: Text(device.name!),
            subtitle: Text(device.address),
            onTap: () async {
              try {
                bool bonded = false;
                if (device.isBonded) {
                  print('Unbonding from ${device.address}...');
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(address);
                  print('Unbonding from ${device.address} has succed');
                } else {
                  print('Bonding with ${device.address}...');
                  bonded = (await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(address))!;
                  print(
                      'Bonding with ${device.address} has ${bonded ? 'succed' : 'failed'}.');
                }
                setState(() {
                  results[results.indexOf(result)] = BluetoothDiscoveryResult(
                      device: BluetoothDevice(
                        name: device.name ?? '',
                        address: address,
                        type: device.type,
                        bondState: bonded
                            ? BluetoothBondState.bonded
                            : BluetoothBondState.none,
                      ),
                      rssi: result.rssi);
                });
              } catch (ex) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Error occured while bonding'),
                          content: Text("${ex.toString()}"),
                          actions: <Widget>[
                             TextButton(
                              child:Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]);
                    });
              }
            },
          );
        },
        itemCount: results.length,
      )),
      backgroundColor: _currentColor,
      body: Center(
        child: CircleColorPicker(
          controller: _controller,
          onChanged: (color) => setState(() {
            _currentColor = color;
          }),
          size: const Size(240, 240),
          strokeWidth: 4,
          thumbSize: 36,
        ),
      ),
    );
  }
}
