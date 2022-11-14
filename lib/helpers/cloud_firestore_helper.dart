import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference authorRef;
  late CollectionReference counterRef;

  connectionWithNotesCollection() {
    authorRef = firebaseFirestore.collection('author');
  }

  connectionWithCounterCollection() {
    counterRef = firebaseFirestore.collection('counter');
  }

  Future<void> insertData({required Map<String, dynamic> data}) async {
    connectionWithCounterCollection();
    connectionWithNotesCollection();

    DocumentSnapshot documentSnapshot =
        await counterRef.doc("author_counter").get();

    Map<String, dynamic> counterData =
        documentSnapshot.data() as Map<String, dynamic>;

    int counter = counterData["counter"];

    await authorRef.doc("${++counter}").set(data);

    await counterRef.doc("author_counter").update({"counter": counter});
  }

  Stream<QuerySnapshot<Object?>> selectRecords() {
    connectionWithNotesCollection();

    return authorRef.snapshots();
  }

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectionWithNotesCollection();

    authorRef.doc(id).update(data);
  }

  Future<void> deleteRecords({required String id}) async {
    connectionWithNotesCollection();

    authorRef.doc(id).delete();
  }
}
