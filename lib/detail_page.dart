import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    final textEditingController = TextEditingController();

    if (isUpdate){
      textEditingController.text = invest.title;
    }

    return ChangeNotifierProvider<MainModel>.value(
      value: model,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '更新' : '追加'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              children: [
                TextField(
                  controller: textEditingController,
                  onChanged: (text) {
                    model.detailText = text;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                RaisedButton(
                  child: Text(isUpdate ? '更新' : '追加'),
                  onPressed: () async {
                    if (isUpdate){
                      await model.update(invest);
                    } else {
                      await model.add();
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
