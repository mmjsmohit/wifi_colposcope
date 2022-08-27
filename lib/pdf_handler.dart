import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:printing/printing.dart';

class PDFHandler {
  late String name;
  late String email;
  late String age;
  late String address;
  late String weight;
  late String height;
  late String comorbidities;
  late String doctorVisitDetails;
  late String doctorName;
  late String hospitalName;
  late String bloodGroup;
  late List<dynamic> comorSnapshots;
  late List<dynamic> snapshots;

  Future<void> setUser() async {
    print('PDFHandler Creation Started');
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    var userDB =
        FirebaseFirestore.instance.collection("users").doc(firebaseUser.email);
    var comorDB = FirebaseFirestore.instance.collection('comorbidities').doc(firebaseUser.email);
    await userDB.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      email = firebaseUser.email!;
      name = data['name'];
      age = data['age'];
      address = data['address'];
      weight = data['weight'];
      height = data['height'];
      comorbidities = data['comorbidities'];
      doctorVisitDetails = data['visit_details'];
      doctorName = data['doctor_name'];
      hospitalName = data['hospital_name'];
      bloodGroup = data['blood_group'];
      snapshots = data['urls'];
      print('Snapshot List is: ${snapshots}');
    });
  await comorDB.get().then((doc) {
    final data = doc.data() as Map<String, dynamic>;
    comorSnapshots = data['comorbidities'];
  },);
    print('Email stored is $email');
    // print('URL List is $snapshots');
    print('PDFHandler creation done!');
  }

  Future<String> createPDF() async {
    final pdf = pw.Document();
    late String pdfUrl;
    final imageQuantity = snapshots.length;
    final comorQuantity = comorSnapshots.length;
    print('imageQuantity is $imageQuantity');
    print('comorQuantity is $comorQuantity');

    // for (int i = 0; i < imageQuantity; i++) {
    //   imageProvider.add(await networkImage(snapshots[i]));
    // }

    //Build PDF according to needs.
    //First add details of user.
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Text('User Details:', style: pw.TextStyle(fontSize: 50)),
            pw.Text('Name: $name', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Address: $address', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Email Address: $email', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Age: $age', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Weight: $weight kgs', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Height: $height cms', style: pw.TextStyle(fontSize: 20)),
            pw.Text('Comorbidities: $comorbidities',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('Doctor Name: $doctorName',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('Doctor Visit Details: $doctorVisitDetails',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('Hospital Name: $hospitalName',
                style: pw.TextStyle(fontSize: 20)),
            pw.Text('Blood Group: $bloodGroup',
                style: pw.TextStyle(fontSize: 20))
          ])); // Center
        },
      ),
    );

    pdf.addPage(
      pw.Page(pageFormat: PdfPageFormat.a4, build: (pw.Context context){
        return pw.Center(child: pw.Text('Comorbidities', style: pw.TextStyle(fontSize: 60),),);
      })
    );


    //Secondly add all the comorbidities.
    for (int i = 0; i < comorQuantity; i++) {
      var netImage = await networkImage(comorSnapshots[i]);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(netImage),
            ); // Center
          },
        ),
      );
    }

    //Thirdly, add all the snapshots.
        pdf.addPage(
      pw.Page(pageFormat: PdfPageFormat.a4, build: (pw.Context context){
        return pw.Center(child: pw.Text('Snapshots', style: pw.TextStyle(fontSize: 60),),);
      })
    );
    for (int i = 0; i < imageQuantity; i++) {
      var netImage = await networkImage(snapshots[i]);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(netImage),
            ); // Center
          },
        ),
      );
    }
    // for (int i = 0; i < imageQuantity; i++) {
    //   pdf.addPage(
    //     pw.Page(
    //       pageFormat: PdfPageFormat.a4,
    //       build: (pw.Context context) {
    //         return pw.Center(
    //           child: pw.Image(imageProvider[i]),
    //         ); // Center
    //       },
    //     ),
    //   );
    // }
    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    final output = await getTemporaryDirectory();
    print('Output Path is ${output.path}');
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
