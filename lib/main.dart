import 'dart:convert';
import 'package:ChristmasTreeApp/helpers/data_change.dart';
import 'package:ChristmasTreeApp/pages/bluetooth_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
      routes: {
        'BluetoothConfig': (BuildContext) => BluetoothPage(),
      },
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
  List<String> patterns = [
    "goBackOneColor",
    "goBackColors",
    "maintainIncrese",
    "maintainDecrese",
    "oddPairsNotSimultaneous",
    "rainbow",
    "rainbowCycle",
    "oneByOne",
  ];

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
      drawer: MainDrawer(
        connection: connection,
        devices: devices,
      ),
      backgroundColor: _currentColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ColorPicker(
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: true,
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: false,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: false,
                    ColorPickerType.wheel: true,
                  },
                  onColorChanged: (color) =>
                      connection?.output.add(dataComing(color: color))),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, i) => 
                      ListTile(title: Text(patterns[i])),
                  itemCount: patterns.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainDrawer extends StatefulWidget {
  List<BluetoothDiscoveryResult>? devices;
  BluetoothConnection? connection;
  MainDrawer({Key? key, @required this.devices, @required this.connection})
      : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBluetoothSerial.instance.onStateChanged(),
            builder: (context, snapshot) {
              BluetoothState? state = snapshot.data;
              if (state == BluetoothState.STATE_ON) {
                List<BluetoothDiscoveryResult>? data = widget.devices;
                return SingleChildScrollView(
                  child: Column(
                    children: data!
                        .map((e) => Container(
                            color: e.device.isConnected
                                ? Colors.green
                                : Colors.blue,
                            child: ListTile(
                                title: Text(e.device.name ?? "No name"),
                                subtitle: Text(e.device.address),
                                onTap: () async {
                                  if (!e.device.isConnected) {
                                    await FlutterBluetoothSerial.instance
                                        .bondDeviceAtAddress(e.device.address);
                                    widget.connection =
                                        await BluetoothConnection.toAddress(
                                            e.device.address);
                                  } else {
                                    await FlutterBluetoothSerial.instance
                                        .removeDeviceBondWithAddress(
                                            e.device.address);
                                  }
                                })))
                        .toList(),
                  ),
                );
              } else {
                return Center(
                    child: IconButton(
                  onPressed: () => {},
                  icon: const Icon(Icons.bluetooth),
                ));
              }
            }));
  }
}
