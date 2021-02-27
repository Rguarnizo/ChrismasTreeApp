part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothEvent {}


class OnSendMessage extends BluetoothEvent{

  final dynamic message;

  OnSendMessage(this.message);


}
