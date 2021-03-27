import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/detail_page.dart';
import 'package:inventory_control/main.dart';
import 'package:inventory_control/main_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Investlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る

    final UserState userState = Provider.of<UserState>(context);
    var user = userState.user;

    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getInvestListRealtime(user.email),
      child: Scaffold(
        appBar: AppBar(
          title: Text('在庫管理アプリ'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // ログアウト処理
                // 内部で保持しているセッション情報が初期化される
                // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
            ),
          ],
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12))),
              child: ListView(
                children: model.investList
                    .map(
                      (invest) => ListTile(
                        leading: Text(invest.title,
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center),
                        title: Text('在庫：' + invest.stock + '個',
                            style: TextStyle(
                                fontSize: 15, color: Colors.blueGrey)),
                        subtitle: Text('最安値：' + invest.low + '円',
                            style: TextStyle(
                                fontSize: 15, color: Colors.blueGrey)),
                        // チェックボックス
                        trailing: Checkbox(
                          value: invest.searchFlg,
                          onChanged: (bool value) {
                            model.updateSearchFlg(invest, value);
                          },
                        ),

                        // タップ、ロングプレスのアクション
                        onLongPress: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('削除しますか？'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      //削除
                                      await model.delete(invest);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('更新しますか？'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            model,
                                            invest: invest,
                                          ),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                    .toList(),
              ));
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

              Expanded(
                flex: 3,
                child: Visibility(
                  child: RaisedButton(
                    child: const Text('レシピ検索'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: const StadiumBorder(),
                    onPressed: () async {
                      _launchUrl(user.email, model);
                    },
                  ),
                ),
              ),

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
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(model),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _launchUrl(String email, MainModel model) async {
    String url = "https://www.google.com/search?q=レシピ%20";
    List<String> args = [];
    for (var invest in model.investList) {
      if (invest.searchFlg) {
        args.add(invest.title);
      }
    }
    url += args.join(' ');

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }
}
