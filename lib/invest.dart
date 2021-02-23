import 'package:cloud_firestore/cloud_firestore.dart';

class Invest {
  Invest.fromCollectionName(String collectionName) {
    this.documentID = "";
    this.account = collectionName;
    this.title = "";
    this.stock = "";
    this.low = "";
    this.createdAt = new DateTime.now();
    this.searchFlg = false;
  }
  Invest(DocumentSnapshot doc) {
    this.documentID = doc.id;
    this.account = doc.data()['account'];
    this.title = doc.data()['title'];
    this.stock = doc.data()['stock'];
    this.low = doc.data()['low'];
    this.createdAt = doc.data()['createdAt'].toDate();
    this.searchFlg = false;
  }

  String account; //アカウント
  String title; // 品名
  String stock; // 在庫数
  String low; //最安値
  DateTime createdAt; // データ作成日
  String documentID;
  bool searchFlg; // Does not update to firestore.
}
