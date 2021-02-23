import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_control/invest.dart';

class MainModel extends ChangeNotifier {
  List<Invest> investList = [];
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

  Future upsert(Invest invest, bool isUpdate) async {
    final collection = FirebaseFirestore.instance.collection(invest.account);
    if (isUpdate) {
      await collection.doc(invest.documentID).update({
        'title': invest.title,
        'stock': invest.stock,
        'low': invest.low,
        'updateAt': Timestamp.now(),
      });
    } else {
      await collection.add({
        'account': invest.account,
        'title': invest.title,
        'stock': invest.stock,
        'low': invest.low,
        'createdAt': Timestamp.now(),
      });
      notifyListeners();
    }
  }

  Future delete(Invest invest) async {
    await FirebaseFirestore.instance
        .collection(invest.account)
        .doc(invest.documentID)
        .delete();
    notifyListeners();
  }

  Future updateSearchFlg(Invest invest, bool searchFlg) async {
    var elem = this
        .investList
        .firstWhere((element) => element == invest, orElse: () => null);
    if (elem != null) {
      elem.searchFlg = searchFlg;
      notifyListeners();
    }
  }
}
