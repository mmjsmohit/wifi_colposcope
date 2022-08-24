import 'dart:typed_data';

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
  SnapshotService snapshot = SnapshotService();

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
                alignment: AlignmentDirectional.bottomEnd,
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
                    child: Text(
                      'Doctor Name',
                      style: TextStyle(color: Colors.black, fontSize: 20),
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
