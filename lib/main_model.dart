import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';

class MainModel extends ChangeNotifier {
  List<Invest> investList = [];
  List<String> selectedItemList = [];
  String accountText = '';
  String titleText = '';
  String stockText = '';
  String lowText = '';

  Future<void> getInvestListRealtime(String collectionName) async {
    final snapshots =
        FirebaseFirestore.instance.collection(collectionName).snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final investList = docs.map((doc) => Invest(doc)).toList();
      investList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
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
    await FirebaseFirestore.instance
        .collection(invest.account)
        .doc(invest.documentID)
        .delete();
    selectedItemList.remove(invest.title);
  }

  Future update(MainModel model, Invest invest) async {
    final document = FirebaseFirestore.instance
        .collection(invest.account)
        .doc(invest.documentID);
    await document.update({
      'title': model.titleText,
      'stock': model.stockText,
      'low': model.lowText,
      'updateAt': Timestamp.now(),
    });
  }

  Future updateSearchFg(Invest invest, bool searchFlg) async {
    if (searchFlg) {
      selectedItemList.add(invest.title);
    } else {
      selectedItemList.remove(invest.title);
    }
  }
}
