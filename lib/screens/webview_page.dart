import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wifi_colposcope/screens/pdf_reader.dart';
import 'package:wifi_colposcope/snapshot_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// late String name;
// late String hospitalName;
late int imageQuantity = 0;

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
  Future<void> setUser() async {
    print('Webviewer Creation Started');
    print('WebViewer creation done!');
  }
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webView;
  late Uint8List screenshotBytes;

  SnapshotService snapshot = SnapshotService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance.collection("users").doc(firebaseUser.email);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WiFi Colposcope App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse("http://192.168.43.62/"),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    child: FutureBuilder(
            future: getHospitalName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final String? hospital_name = snapshot.data;
              return Text('${user.displayName}\n$hospital_name', style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),);
            }),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final snackBar = SnackBar(
                      content: const Text(
                          'Snapshot has been uploaded to the database!'),
                      backgroundColor: Colors.green,
                    );
                    Uint8List screenshotBytes =
                        (await webView.takeScreenshot())!;
                    snapshot.uploadFile(user.email!, screenshotBytes);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text('Take a snapshot!'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => PDFReader())));
                    // if (imageQuantity < 1) {
                    //   final snackBar = SnackBar(
                    //     content: const Text(
                    //         'Take atleast one snapshot to generate report!'),
                    //     backgroundColor: Colors.red,
                    //   );
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // } else {

                    // }
                  },
                  child: Text('Generate PDF Report!'),
                )
              ],
            ),
            Column(
              children: [
                Text('You are logged in as ${user.displayName}'),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.arrow_back, size: 32),
                  label: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Future<String> getHospitalName() async {
        final firebaseUser = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance.collection("users").doc(firebaseUser.email);
    late String hospitalName;
    await db.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      // name = data['name'];
      hospitalName = data['hospital_name'];
    });
    return hospitalName;

  }
}
