import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_colposcope/screens/pdf_reader.dart';
import 'package:wifi_colposcope/snapshot_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webView;
  late Uint8List screenshotBytes;
  late String doctorName;
  late String hospitalName;

  SnapshotService snapshot = SnapshotService();

  Future<void> initializeDetails() async {
    final user = FirebaseAuth.instance.currentUser!;
    var db = FirebaseFirestore.instance.collection("users").doc(user.email);
    await db.get().then((doc) {
      final data = doc.data() as Map<String, dynamic>;
      doctorName = data['doctor_name'];
      hospitalName = data['hospital_name'];
    });
  }

  @override
  void initState() {
    initializeDetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WiFi Colposcope App'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Container(
                    child: InAppWebView(
                        initialUrlRequest: URLRequest(
                          url: Uri.parse("http://google.com/"),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          webView = controller;
                        }),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          doctorName,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Text(
                          hospitalName,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
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
                  },
                  child: Text('Generate PDF Report!'),
                )
              ],
            ),
            Column(
              children: [
                Text('You are logged in as ${user.email!}'),
                Text(user.uid),
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
}
