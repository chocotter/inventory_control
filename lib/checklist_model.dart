import 'package:flutter/material.dart';
import 'package:inventory_control/main_model.dart';

class CheckboxListTileForm extends StatefulWidget {
  CheckboxListTileForm(BuildContext context, MainModel model);

  @override
  _CheckboxListTileState createState() => _CheckboxListTileState();
}

class _CheckboxListTileState extends State<CheckboxListTileForm> {
  bool _checkBox = false;

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Checkbox(
          value: _checkBox,
          onChanged: (bool value) {
            setState(() {
              _checkBox = value;
            });
          },
        ),
      ],
    ));
  }
}
