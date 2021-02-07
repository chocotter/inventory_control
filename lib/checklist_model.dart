import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';
import 'package:inventory_control/main_model.dart';

// ignore: must_be_immutable
class CheckboxListTileForm extends StatefulWidget {
  final MainModel model;
  final Invest invest;

  CheckboxListTileForm(this.model, this.invest);

  @override
  _CheckboxListTileState createState() =>
      _CheckboxListTileState(this.model, this.invest);
}

class _CheckboxListTileState extends State<CheckboxListTileForm> {
  final MainModel model;
  final Invest invest;
  bool _checkBox = false;

  _CheckboxListTileState(this.model, this.invest);

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
            model.updateSearchFg(invest, _checkBox);
          },
        ),
      ],
    ));
  }
}
