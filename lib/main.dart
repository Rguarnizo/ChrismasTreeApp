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

  bool isDiscovering = false;
  String? deviceAdress;
  List<BluetoothDiscoveryResult> devices = [];
  BluetoothConnection? connection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterBluetoothSerial.instance.startDiscovery().listen((btDev) {
      setState(() {
        devices.add(btDev);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
          child: SingleChildScrollView(
        child: Column(
          children: devices
              .map((e) => Container(
                  color: e.device.isConnected ? Colors.green : Colors.blue,
                  child: ListTile(
                      title: Text(e.device.name ?? "No name"),
                      subtitle: Text(e.device.address),
                      onTap: () async {
                        if (!e.device.isConnected) {
                          await FlutterBluetoothSerial.instance
                              .bondDeviceAtAddress(e.device.address);
                          connection = await BluetoothConnection.toAddress(
                              e.device.address);
                        } else {
                          await FlutterBluetoothSerial.instance
                              .removeDeviceBondWithAddress(e.device.address);
                        }
                      })))
              .toList(),
        ),
      )),
      backgroundColor: _currentColor,
      body: Center(
        child: CircleColorPicker(
          controller: _controller,
          onChanged: (color) => setState(() {
            _currentColor = color;
            connection?.output.add(ascii.encode(json.encode(
          {
            "Colors": {
              "Red": color.red,
              "Green": color.green,
              "Blue": color.blue
            },
            "Strip": 1,
            "Pattern": 2
          }
            )));
          }),
          size: const Size(240, 240),
          strokeWidth: 4,
          thumbSize: 36,
        ),
      ),
    );
  }
}
