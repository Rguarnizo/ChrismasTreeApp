import 'package:chrismas_tree_app/BLoC/Bluetooth/bluetooth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: BlocProvider(
          create: (_) => BluetoothBloc(),
          child: Drawer(
            child: BlocBuilder<BluetoothBloc, BluetoothState>(
              builder: (context, state) {
                BlocProvider.of<BluetoothBloc>(context).add(GetScansResults());
                print(state);
                return Column(
                  children: state is ScanResults
                      ? state.results.map((element) {
                          final device = element.device;
                          return ListTile(
                            title: Text(device.name),
                            subtitle: Text(device.id.toString()),
                          );
                        }).toList()
                      : [Container()],
                );
              },
            ),
          ),
        ),
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
