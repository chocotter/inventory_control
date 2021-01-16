import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/detail_page.dart';
import 'package:inventory_control/main_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chocotter Invest Control',
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()..getInvestListRealtime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('在庫管理アプリ'),
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          final investList = model.investList;
          return ListView(
            children: investList
                .map(
                  (invest) => ListTile(
                title: Text(invest.title),
                leading: Icon(Icons.account_circle),
                trailing: CheckboxListTileForm(),
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
                              await Navigator.of(context).pop();
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
                              await Navigator.of(context).pop();
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
          );
        }),
        floatingActionButton:
        Consumer<MainModel>(builder: (context, model, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                child: RaisedButton(
                  child: const Text('Search'),
                  onPressed: () {},
                  highlightElevation: 16,
                  highlightColor: Colors.blue,
                  onHighlightChanged: (value) {},
                ),
                visible: false,
              ),
              Visibility(
                child: RaisedButton(
                  child: const Text('Search'),
                  onPressed: () {},
                  highlightElevation: 16,
                  highlightColor: Colors.blue,
                  onHighlightChanged: (value) {},
                ),
                visible: false,
              ),
              Visibility(
                child: RaisedButton(
                  child: const Text('Search'),
                  onPressed: () {},
                  highlightElevation: 16,
                  highlightColor: Colors.blue,
                  onHighlightChanged: (value) {},
                ),
                visible: false,
              ),
              RaisedButton(
                child: const Text('Search'),
                color: Colors.blue,
                textColor: Colors.white,
                shape: const StadiumBorder(),
                onPressed: () async {
                  _launchUrl();
                },
              ),
              FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(model),
                      fullscreenDialog: true,
                    ),
                  );
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _launchUrl() async {
    const url = "https://www.google.com/search?q=レシピ%20すいか%20らいち%20";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }
}

class CheckboxListTileForm extends StatefulWidget {
  @override
  _CheckboxListTileState createState() => _CheckboxListTileState();
}
class _CheckboxListTileState extends State<CheckboxListTileForm> {
  var _checkBox1 = false;

  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Checkbox(
              value: _checkBox1,
              onChanged: (bool value) {
                setState(() {
                  _checkBox1 = value;
                });
              },
            ),
          ],
        ));
  }
}
