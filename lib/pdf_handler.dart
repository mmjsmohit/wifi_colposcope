import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PDFHandler {
  Future<String> createPDF() async {
    final pdf = pw.Document();
    late String pdfUrl;

    //Build PDF according to needs.
    //First add details of user.
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(getDetails()),
          ); // Center
        },
      ),
    );
    //Secondly add all the snapshots.
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        },
      ),
    );
    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    final output = await getTemporaryDirectory();
    final File file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
    pdfUrl = await uploadFile(file);
    return pdfUrl;
  }

  String getDetails() {
    final user = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance.collection("users").doc(user.email);
    String userAddress =
        'User Address Not Obtained. Make sure you are connected to Internet.';
    db.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      userAddress = data['address'];
      print(userAddress);
    });
    return userAddress;
  }

  Future<String> uploadFile(File pdf) async {
    String url = '';
    late firebase_storage.Reference ref;
    final user = FirebaseAuth.instance.currentUser!;
    DocumentReference docRef;
    docRef = FirebaseFirestore.instance.collection('users').doc(user.email);
    final Directory tempDir = await getTemporaryDirectory();
    ref = firebase_storage.FirebaseStorage.instance.ref().child(
        '${user.email}/reports/${DateTime.now().millisecondsSinceEpoch}');

    await ref.putFile(pdf).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        docRef.update({
          'reports': value,
        });
        url = value;
      });
    });
    return url;
  }
}
