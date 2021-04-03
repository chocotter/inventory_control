import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/investlist.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 最初に表示するWidget
  runApp(MyApp());
}

class UserState extends ChangeNotifier {
  var user;

  void setUser(var currentUser) {
    user = currentUser;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final UserState userState = UserState();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
      value: userState,
      child: MaterialApp(
        // 右上に表示される"debug"ラベルを消す
        debugShowCheckedModeBanner: false,
        title: 'Chocotter Invest Control',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/LoginPage': (_) => new LoginPage(),
          '/Investlist': (_) => new Investlist(),
        },
        home: LoginCheck(),
      ),
    );
  }
}

class LoginCheck extends StatefulWidget {
  LoginCheck({Key key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態のチェック(非同期で行う)
  void checkUser() async {
    final currentUser = await FirebaseAuth.instance.currentUser;
    final userState = Provider.of<UserState>(context, listen: false);
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, "/LoginPage");
    } else {
      userState.setUser(currentUser);
      Navigator.pushReplacementNamed(context, "/Investlist");
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';

  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      var result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      var user = result.user;
                      userState.setUser(user);

                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return Investlist();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.message}";
                      });
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlineButton(
                  textColor: Colors.blue,
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      var result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      var user = result.user;
                      // ユーザー情報を更新
                      userState.setUser(user);

                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          // ユーザー情報を渡す
                          return Investlist();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.message}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
