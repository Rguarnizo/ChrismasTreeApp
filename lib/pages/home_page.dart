
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
            child: StreamBuilder<List<ScanResult>>(
          stream: FlutterBlue.instance.scanResults,
          builder: (_, snapshot) {
            return ListView(
                children: snapshot.hasData
                    ? snapshot.data.map((scan) => ListTile(
                          title: Text(scan.device.name),
                        )).toList()
                    : []);
          },
        )),
        backgroundColor: Colors.blueGrey[800],
        body: SafeArea(
          child: Column(
            children: [
              Text(
                'Change Primary Color',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              _ChangePrimaryColor(),
              Flexible(
                child: Container(),
              ),
              Text(
                'Change Secondary Color',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              _ChangeSecondaryColor(),
            ],
          ),
        ));
  }
}

class _ChangeSecondaryColor extends StatelessWidget {
  const _ChangeSecondaryColor({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        CircleColorPicker(
          onChanged: (color) => null,
          strokeWidth: 5,
        ),
      ],
    ));
  }
}

class _ChangePrimaryColor extends StatelessWidget {
  const _ChangePrimaryColor({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        CircleColorPicker(
          strokeWidth: 5,
          onChanged: (color) => null,
        ),
      ],
    ));
  }
}
