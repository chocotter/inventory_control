import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';
import 'package:provider/provider.dart';

class DetailPageField extends StatelessWidget {
  final String label;
  DetailPageField(this.label);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = new TextEditingController();
    Invest invest = Provider.of<Invest>(context);
    textEditingController.text = getTartget(this.label, invest);

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 350,
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: this.label,
              ),
              onChanged: (text) {
                switch (this.label) {
                  case '品名':
                    invest.title = text;
                    break;
                  case '在庫数':
                    invest.stock = text;
                    break;
                  case '最安値':
                    invest.low = text;
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String getTartget(String arg, Invest invest) {
    switch (arg) {
      case '品名':
        return invest.title;
        break;
      case '在庫数':
        return invest.stock;
        break;
      case '最安値':
        return invest.low;
        break;
      default:
        return "";
        break;
    }
  }
}
