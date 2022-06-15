
import 'dart:io';
import 'package:driverassistant/CameraPreview.dart';
import 'package:driverassistant/Login_Screen.dart';
import 'package:driverassistant/video_page.dart';
import 'package:file_saver/file_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:driverassistant/view_file.dart' if (dart.library.html) 'save_file_web.dart';
class view_pdf extends StatefulWidget {

  const view_pdf({Key key}) : super(key: key);

  @override
  _view_pdfState createState() => _view_pdfState();
}
class _view_pdfState extends State<view_pdf> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        elevation: 0,
        backgroundColor: Colors.black26,
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children:[
                TextButton(onPressed:generatefile, child: Text("View"))
              ],
            ),
          ],
        ),

      ),
    );
  }

  Future<void> generatefile() async {
    print("file bnaunga hehe");
    final PdfDocument document = PdfDocument();
    PdfPage page1 = document.pages.add();
    print("file page hehe");
    //String data="abc";

    page1.graphics.drawString(
        "Accident Report ", PdfStandardFont(PdfFontFamily.helvetica,20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(168, 10, 450, 50));

    page1.graphics.drawString(
       "User Email: "+Name.email2+"\n", PdfStandardFont(PdfFontFamily.helvetica,12),
       brush: PdfSolidBrush(PdfColor(0, 0, 0)),
       bounds: Rect.fromLTWH(0, 80, 450, 100));

    PdfPage page = document.pages[0];
    Size clientSize = page.getClientSize();
   page.graphics.drawString(
        "Location : "+Info.locationu, PdfStandardFont(PdfFontFamily.helvetica,12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        //bounds: Rect.fromLTWH(0, 0, 450, 180));
        bounds: Rect.fromLTWH( 0,100,450,120));
    // page.graphics.drawString(
    //     'SMS sent to Numbers : '+"\n", PdfStandardFont(PdfFontFamily.helvetica,20),
    //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //     bounds: Rect.fromLTWH(0, 50, 450, 250));
double temp=200;
    for(int i=0;i<Info.emerg.length;i++) {
      page.graphics.drawString(
          'SMS sent to : '+Info.emerg[i].toString(), PdfStandardFont(PdfFontFamily.helvetica,12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds:  Rect.fromLTWH(0, temp,450, 250));
      temp+=50;
    }
   /* page.graphics.drawString(
        'Email sent to Emails : ', PdfStandardFont(PdfFontFamily.helvetica,32),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
       bounds:  Rect.fromLTWH(0, temp+50, 450, 250));
*/
    for(int i=0;i<Info.emailsg.length;i++) {
      page.graphics.drawString(
         "Email sent to : "+ Info.emailsg[i].toString(), PdfStandardFont(PdfFontFamily.helvetica,12),
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds:  Rect.fromLTWH(0, temp, 450, 250));
      temp+=50;
    }
    // page.graphics.drawString(
    //     Rec.vidlink, PdfStandardFont(PdfFontFamily.helvetica,32),
    //     brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //     bounds: const Rect.fromLTWH(0, 0, 150, 20));

    List<int> bytes = document.save();
    document.dispose();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    File file = File('$path/Oukli1.pdf');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/Oukli1.pdf');
    // String path = await FileSaver.instance.saveFile(
    //     data,
    //     "xlsx",
    //     mimeType: type
    // );
    //print(path);

 }
}


