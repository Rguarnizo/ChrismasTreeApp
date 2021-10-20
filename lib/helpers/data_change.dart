import 'dart:convert';
import 'dart:typed_data';

import 'dart:ui';

import 'package:flutter/cupertino.dart';

Uint8List dataComing({@required Color? color}) {
  return ascii.encode(json.encode({
    "Colors": {"Red": color?.red, "Green": color?.green, "Blue": color?.blue},
    "Strip": 1,
    "Pattern": 2
  }));
}
