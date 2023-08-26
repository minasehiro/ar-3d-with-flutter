import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const viewTypeStr = "arNativeView";

class ArNative extends StatelessWidget {
  const ArNative({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return const Placeholder();
    } else {
      return const UiKitView(
        viewType: viewTypeStr,
        layoutDirection: TextDirection.ltr,
        creationParams: null,
        creationParamsCodec: StandardMessageCodec(),
      );
    }
  }
}
