import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';

class MainModel extends ChangeNotifier {
  List<Invest> investList = [];
  String accountText = '';
  String titleText = '';
  String stockText = '';
  String lowText = '';

  /*
  Future getInvestList() async {
    final snapshot = await FirebaseFirestore.instance.collection('investList').get();
    final docs = snapshot.docs;
    final investList = docs.map((doc) => Invest(doc)).toList();
    this.investList = investList;
    notifyListeners();
  }
  */

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
}
