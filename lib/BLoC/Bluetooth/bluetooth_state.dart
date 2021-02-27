part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothState {}

class BluetoothInitial extends BluetoothState {

}

class ScanResults extends BluetoothState{
  final List<ScanResult> results;

  ScanResults(this.results);

}
