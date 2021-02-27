import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meta/meta.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  BluetoothBloc() : super(BluetoothInitial());

  final bluetooth = FlutterBlue.instance;

  @override
  Stream<BluetoothState> mapEventToState(
    BluetoothEvent event,
  ) async* {
    
    if(event is OnSendMessage)   yield BluetoothInitial();
    if(event is GetScansResults) yield* _emitScansResults();
    
  }

  Stream<BluetoothState> _emitScansResults() async* {
    
    bluetooth.startScan(timeout: Duration(seconds: 10));
    yield ScanResults(await bluetooth.scanResults.last);

  }
}
