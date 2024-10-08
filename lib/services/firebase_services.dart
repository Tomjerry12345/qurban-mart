import 'dart:typed_data';
import 'package:admin_qurban_mart/values/output_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// ignore: depend_on_referenced_packages

class FirebaseServices {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getUser() => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();

  Future<UserCredential> registerWithEmailAndPassword(
          String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInWithEmailAndPassword(
          String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future addDataCollection(String collection, Map<String, dynamic> data) async {
    final res = await _db.collection(collection).add(data);
    await updateDataSpecifictDoc(collection, res.id, {...data, "id": res.id});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreamCollection(
          String collection) =>
      _db.collection(collection).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDataStreamDoc(
          String collection, String doc) =>
      _db.collection(collection).doc(doc).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getDataQueryStream(
          String collection, String query, dynamic value) =>
      _db.collection(collection).where(query, isEqualTo: value).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> getDataTwoQueryStream(
          String collection,
          String query,
          dynamic value,
          String query1,
          dynamic value1) =>
      _db
          .collection(collection)
          .where(query, isEqualTo: value)
          .where(query1, isEqualTo: value1)
          .snapshots();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDataCollection(
      String collection) async {
    final data = await _db.collection(collection).get();

    return data.docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDataDoc(
      String collection, String doc) async {
    final data = await _db.collection(collection).doc(doc).get();

    return data;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDataCollectionByQuery(
          String collection, String query, dynamic value) async {
    final data =
        await _db.collection(collection).where(query, isEqualTo: value).get();

    return data.docs;
  }

  Future<void> updateDataAllDoc(String collection, String doc, data) async =>
      _db.collection(collection).doc(doc).set(data);

  Future<void> updateDataSpecifictDoc(
          String collection, String doc, dynamic data) async =>
      _db.collection(collection).doc(doc).update(data);

  Future<void> updateDataCollectionByQuery(
      String collection, String query, dynamic value) async {
    final res =
        await _db.collection(collection).where(query, isEqualTo: value).get();
    logO("res", m: res.size);
    await res.docs[0].data().update(query, value);
  }

  void updateDataCollectionByTwoQuery(String collection, String query,
      dynamic value, String query1, dynamic value1) async {
    final res =
        await _db.collection(collection).where(query, isEqualTo: value).get();

    final ref = res.docs[0].reference;

    final batch = _db.batch();
    batch.update(ref, {query1: value1});
    batch.commit();
  }

  Future<void> updateIsLoggin(bool status) async =>
      _db.collection("isLoggin").doc("1").update({"status": status});

  Future<void> deleteDoc(String collection, String doc) async =>
      _db.collection(collection).doc(doc).delete();

  Future uploadFile(Uint8List file, String fileName, String type) async {
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$type/$fileName');
    final uploadTask = await firebaseStorageRef.putData(file);
    final taskSnapshot = uploadTask.ref.getDownloadURL();
    return taskSnapshot;
  }
}
