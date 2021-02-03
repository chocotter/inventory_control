import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';
import 'package:url_launcher/url_launcher.dart';

class MainModel extends ChangeNotifier {
  List<Invest> investList = [];
  String accountText = '';
  String titleText = '';
  String stockText = '';
  String lowText = '';
  bool searchFlg = false;

  void getInvestListRealtime(String collectionName) {
    final snapshots =
        FirebaseFirestore.instance.collection(collectionName).snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final investList = docs.map((doc) => Invest(doc)).toList();
      investList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      this.investList = investList;
      notifyListeners();
    });
  }


  Future add(String collectionName) async {
    final collection = FirebaseFirestore.instance.collection(collectionName);
    await collection.add({
      'account': accountText,
      'title': titleText,
      'stock': stockText,
      'low': lowText,
      'createdAt': Timestamp.now(),
      'searchFg': searchFlg,
    });
  }

  Future delete(Invest invest) async {
    await Firestore.instance
        .collection(invest.account)
        .document(invest.documentID)
        .delete();
  }

  Future update(Invest invest) async {
    final document =
        Firestore.instance.collection(invest.account).document(invest.documentID);
    await document.updateData({
      'title': titleText,
      'stock': stockText,
      'low': lowText,
      'updateAt': Timestamp.now(),
    });
  }


  Future updateSearchFg(Invest invest, bool searchFlg) async {
    final document =
    Firestore.instance.collection(invest.account).document(invest.documentID);
    await document.updateData({
      'searchFg': searchFlg,
    });
  }




  void getInvestList(String collectionName) async {
    List<Invest> investList2 = [];

    final snapshots =
    FirebaseFirestore.instance.collection(collectionName).snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final investList2 = docs.map((doc) => Invest(doc)).toList();

      print("aaaaaaaaaaaaaaaaaaaa");
      print(investList2[0]);

    });
  }


}
