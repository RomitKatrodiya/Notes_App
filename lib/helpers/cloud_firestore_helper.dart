import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference notesRef;
  late CollectionReference counterRef;

  connectionWithNotesCollection() {
    notesRef = firebaseFirestore.collection('notes');
  }

  connectionWithCounterCollection() {
    counterRef = firebaseFirestore.collection('counter');
  }

  Future<void> insertData({required Map<String, dynamic> data}) async {
    connectionWithCounterCollection();
    connectionWithNotesCollection();

    DocumentSnapshot documentSnapshot =
        await counterRef.doc("note_counter").get();

    Map<String, dynamic> counterData =
        documentSnapshot.data() as Map<String, dynamic>;

    int counter = counterData["counter"];

    await notesRef.doc("${++counter}").set(data);

    await counterRef.doc("note_counter").update({"counter": counter});
  }

  Stream<QuerySnapshot<Object?>> selectRecords() {
    connectionWithNotesCollection();

    return notesRef.snapshots();
  }

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectionWithNotesCollection();

    notesRef.doc(id).update(data);
  }

  Future<void> deleteRecords({required String id}) async {
    connectionWithNotesCollection();

    notesRef.doc(id).delete();
  }
}
