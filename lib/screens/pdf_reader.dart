import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../pdf_handler.dart';
import 'package:share_plus/share_plus.dart';

class PDFReader extends StatelessWidget {
  PDFReader({Key? key}) : super(key: key);

  late String pdfPath;

  Future<String> pdfurl() async {
    final PDFHandler pdfHandler = PDFHandler();
    await pdfHandler.setUser();
    final pdfUrl = await pdfHandler.createPDF();
    return pdfUrl;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Share.shareFiles([
                  '/data/user/0/com.example.wifi_colposcope/cache/report.pdf'
                ]);
              },
              icon: Icon(Icons.share),
              tooltip: 'Share PDF Report',
            )
          ],
          title: Text('PDF Report'),
        ),
        body: FutureBuilder(
            future: pdfurl(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final String? pdfUrl = snapshot.data;
              return SfPdfViewer.network(pdfUrl!);
            }),
      ),
    );
  }
}
