import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';
import 'package:inventory_control/main.dart';
import 'package:inventory_control/main_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage(this.model, {this.invest});

  final MainModel model;
  final Invest invest;

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    var user = userState.user;

    final bool isUpdate = invest != null;
    final textEditingControllerTitle = TextEditingController();
    final textEditingControllerStock = TextEditingController();
    final textEditingControllerLow = TextEditingController();

    if (isUpdate) {
      textEditingControllerTitle.text = invest.title;
      textEditingControllerStock.text = invest.stock;
      textEditingControllerLow.text = invest.low;

      model.titleText = invest.title;
      model.stockText = invest.stock;
      model.lowText = invest.low;
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
                    onPressed: () {},
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
                        await model.update(model, invest);
                      } else {
                        await model.add(user.email);
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
                    onPressed: () {},
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
                      await model.update(model, invest);
                    } else {
                      model.accountText = user.email;
                      await model.add(model.accountText);
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
    child: Column(children: [
      TextField(
        controller: textEditingControllerTitle,
        decoration: InputDecoration(
          labelText: "品名",
        ),
        onChanged: (text) {
          model.titleText = text;
        },
      ),
    ]),
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
            Center(child: Text(_date.toString())),
            new RaisedButton(
              onPressed: () => _selectDate(context),
              child: new Text('日付選択'),
            )
          ],
        ));
  }
}
