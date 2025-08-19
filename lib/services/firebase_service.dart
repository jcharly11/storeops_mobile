
  import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

class FirebaseService {


static Future<void> insertTokenMobile(String accountNumber, String storeId, String token) async {
  try {
    
    await firestore.collection('mobile_tokens').add({
      'accountNumber': accountNumber,
      'storeId': storeId,
      'token': token
    });

    print("Documento agregado con ID automático ✅");
  } catch (e) {
    print("Error al insertar: $e");
  }
}

static Future<String> tokenMobileExists(String token) async {
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    
    snapshot = await FirebaseFirestore.instance
    .collection('mobile_tokens')
    .where('token', isEqualTo: token)
    .get();
    
    
    if(snapshot.size>0){
      String docId= snapshot.docs.first.id; 
      return docId;
    }
    else {
      return '';
    }
}

static Future<void> updateInfoTokenMobile(String accountNumber, String storeId, String docId) async {
    await FirebaseFirestore.instance
      .collection('mobile_tokens')
      .doc(docId)
      .update({
        'accountNumber': accountNumber,
        'storeId': storeId,
      });
}





}