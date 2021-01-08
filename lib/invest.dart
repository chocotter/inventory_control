import 'package:cloud_firestore/cloud_firestore.dart';

class Invest {
  Invest(DocumentSnapshot doc) {
    this.documentID = doc.documentID;
    this.title = doc.data()['title'];
    final Timestamp timestamp = doc.data()['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String title;
  DateTime createdAt;
  String documentID;
}
