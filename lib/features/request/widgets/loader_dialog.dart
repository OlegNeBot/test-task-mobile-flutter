import 'package:flutter/material.dart';

Future<void> showLoaderDialog(BuildContext context) async => await showDialog(
  context: context,
  barrierDismissible: false,
  builder:
      (context) => Container(
        color: Colors.black12.withAlpha(15),
        child: Center(child: CircularProgressIndicator()),
      ),
);
