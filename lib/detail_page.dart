import 'package:flutter/material.dart';
import 'package:inventory_control/detail_page_field.dart';
import 'package:inventory_control/invest.dart';
import 'package:inventory_control/main_model.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage(this.model, {this.invest});

  final MainModel model;
  Invest invest;

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = invest != null;

    if (!isUpdate) {
      this.invest = new Invest.fromCollectionName(model.collectionName);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainModel>.value(value: model),
        Provider<Invest>.value(value: invest),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '更新' : '追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DetailPageField('品名'),
                DetailPageField('在庫数'),
                DetailPageField('最安値'),
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
                // update from onTap()
                flex: 3,
                child: Visibility(
                  child: RaisedButton(
                    child: Text(isUpdate ? '更新' : '追加'),
                    onPressed: () async {
                      await model.upsert(invest, isUpdate);
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
                // update from add
                flex: 2,
                child: FloatingActionButton(
                  onPressed: () async {
                    await model.upsert(invest, isUpdate);
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
