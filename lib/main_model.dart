import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';

class MainModel extends ChangeNotifier {
  List<Invest> investList = [];
  List<String> selectedItemList = [];
  String collectionName = '';

  Future<void> getInvestListRealtime(String collectionName) async {
    this.collectionName = collectionName;
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

  Future add(Invest invest) async {
    final collection =
        FirebaseFirestore.instance.collection(this.collectionName);
    await collection.add({
      'account': invest.account,
      'title': invest.title,
      'stock': invest.stock,
      'low': invest.low,
      'createdAt': Timestamp.now(),
    });
    notifyListeners();
  }

  Future delete(Invest invest) async {
    await FirebaseFirestore.instance
        .collection(invest.account)
        .doc(invest.documentID)
        .delete();
    selectedItemList.remove(invest.title);
    notifyListeners();
  }

  Future update(Invest invest) async {
    final document = FirebaseFirestore.instance
        .collection(invest.account)
        .doc(invest.documentID);
    await document.update({
      'title': invest.title,
      'stock': invest.stock,
      'low': invest.low,
      'updateAt': Timestamp.now(),
    });
    notifyListeners();
  }

  Future updateSearchFg(Invest invest, bool searchFlg) async {
    if (searchFlg) {
      selectedItemList.add(invest.title);
    } else {
      selectedItemList.remove(invest.title);
    }
  }
}
