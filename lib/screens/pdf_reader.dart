
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../pdf_handler.dart';

class PDFReader extends StatelessWidget {
  PDFReader({Key? key}) : super(key: key);

  Future<String> pdfurl() async {
    final PDFHandler pdfHandler = PDFHandler();
    final pdfUrl = await pdfHandler.createPDF();
    return pdfUrl;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
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
