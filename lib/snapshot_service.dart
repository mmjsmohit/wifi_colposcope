import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class SnapshotService {
  Future<void> uploadFile(String emailAddress, Uint8List imageData) async {
    late firebase_storage.Reference ref;
    final user = FirebaseAuth.instance.currentUser!;
    DocumentReference docRef;
    docRef = FirebaseFirestore.instance.collection('users').doc(user.email);
    final Directory tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/snapshot${DateTime.now().millisecondsSinceEpoch}')
        .create();
    file.writeAsBytesSync(imageData);
    ref = firebase_storage.FirebaseStorage.instance.ref().child(
        '$emailAddress/images/snapshots/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(file).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        docRef.update({
          'urls': FieldValue.arrayUnion([value]),
        });
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        docRef.update({
          'timestamps': FieldValue.arrayUnion([formattedDate]),
        });
      });
    });
  }
}
