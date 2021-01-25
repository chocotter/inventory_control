import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_control/invest.dart';
import 'package:inventory_control/main_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage(this.model, {this.invest});

  final MainModel model;
  final Invest invest;

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = invest != null;
    final textEditingControllerTitle = TextEditingController();
    final textEditingControllerStock = TextEditingController();
    final textEditingControllerLow = TextEditingController();

    if (isUpdate) {
      textEditingControllerTitle.text = invest.title;
      textEditingControllerStock.text = invest.stock;
      textEditingControllerLow.text = invest.low;
    }

    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '更新' : '追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleArea(model, textEditingControllerTitle),
                _stockArea(model, textEditingControllerStock),
                _lowArea(model, textEditingControllerLow),
              ],
            ),
          );
        }),
        floatingActionButton:
            Consumer<MainModel>(builder: (context, model, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // サイズ調整用 START
              Expanded(
                flex: 4,
                child: Visibility(
                  child: RaisedButton(
                      // サイズ調整用
                      ),
                  visible: false,
                ),
              ),
              // サイズ調整用 END

              // サイズ調整用 START
              Expanded(
                flex: 3,
                child: Visibility(
                  child: RaisedButton(
                    child: Text(isUpdate ? '更新' : '追加'),
                    onPressed: () async {
                      if (isUpdate) {
                        await model.update(invest);
                      } else {
                        await model.add();
                      }
                      Navigator.pop(context);
                    },
                  ),
                  visible: false,
                ),
              ),
              // サイズ調整用 END

              // サイズ調整用 START
              Expanded(
                flex: 1,
                child: Visibility(
                  child: RaisedButton(
                      // サイズ調整用
                      ),
                  visible: false,
                ),
              ),
              // サイズ調整用 END

              Expanded(
                flex: 2,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (isUpdate) {
                      await model.update(invest);
                    } else {
                      await model.add();
                    }
                    Navigator.pop(context);
                  },
                  child: isUpdate ? Icon(Icons.update) : Icon(Icons.edit),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Widget _titleArea(
  MainModel model,
  TextEditingController textEditingControllerTitle,
) {
  return Container(
    width: 350,
    child: Column(
      children: [
        TextField(
          controller: textEditingControllerTitle,
          decoration: InputDecoration(
            labelText: "品名",
          ),
          onChanged: (text) {
            model.titleText = text;
          },
        ),
      ],
    ),
  );
}

Widget _stockArea(
  MainModel model,
  TextEditingController textEditingControllerStock,
) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 350,
          child: TextField(
            controller: textEditingControllerStock,
            decoration: InputDecoration(
              labelText: '在庫数',
            ),
            onChanged: (text) {
              model.stockText = text;
            },
          ),
        ),
      ],
    ),
  );
}

Widget _lowArea(
  MainModel model,
  TextEditingController textEditingControllerLow,
) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 350,
          child: TextField(
            controller: textEditingControllerLow,
            decoration: InputDecoration(
              labelText: '最安値',
            ),
            onChanged: (text) {
              model.lowText = text;
            },
          ),
        ),
        /*
        IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () async {
              await ChangeForm();
            }),

         */
      ],
    ),
  );
}

Widget _deadLineArea() {
  return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(
        // 1行目
        children: <Widget>[
          Expanded(
            // 2.1列目
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  // 3.1.1行目
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    "Neko is So cute..",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                Container(
                  // 3.1.2行目
                  child: Text(
                    "Osaka, Japan",
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            // 2.2列目
            Icons.star,
            color: Colors.red,
          ),
          Text('41'), // 2.3列目
        ],
      ));
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  DateTime _date = new DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) setState(() => _date = picked);
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: <Widget>[
            Center(child: Text("${_date}")),
            new RaisedButton(
              onPressed: () => _selectDate(context),
              child: new Text('日付選択'),
            )
          ],
        ));
  }
}
