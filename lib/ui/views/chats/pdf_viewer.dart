import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sesa/ui/utils/storage.dart';

import '../../utils/SizeConfig.dart';
import '../../utils/colors.dart';

class PDFViewer extends StatefulWidget {
  final String url;
  final String senderDoc;
  const PDFViewer({Key? key, required this.url, required this.senderDoc})
      : super(key: key);

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool _isLoading = true;
  //late PDFDocument _pdf;
  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    var tempDir = await getTemporaryDirectory();
    print(tempDir.parent);
    print(directory.path);
    final File file = File(
        '${directory.path}/${widget.senderDoc}-${DateTime.now().millisecondsSinceEpoch.toString()}.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(widget.url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveFile() async {
    String name = await readStorage(value: "name");
    try {
      if (await _requestPermission(Permission.manageExternalStorage)) {
        Directory? directory;
        directory = Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory(); //FOR IOS

        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/FELICITY/${widget.senderDoc}";
        directory = Directory(newPath);
        print("Directory look : $directory");

        File saveFile = File(directory.path +
            "/${widget.senderDoc}-${DateTime.now().millisecondsSinceEpoch.toString()}.pdf");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          print("DIRECTORY CREATE");
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          print("DOCUMENTS SAVE");
          await Dio().download(
            widget.url,
            saveFile.path,
          );
          Navigator.pop(context);
          /* showSnackBar(
              context: context,
              message:
                  "The file have been download to the folder FELICITY/${widget.senderDoc}",
              isError: false); */
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void loadPdf() async {
    String pdfFlePath1 = await downloadAndSavePdf();
    if (!mounted) return;
    setState(() {
      pdfFlePath = pdfFlePath1;
    });
  }

  void download() async {}

  /* void _loadFile() async {
    // Load the pdf file from the internet
    _pdf = await PDFDocument.fromURL(
        'https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf');

    setState(() {
      _isLoading = false;
    });
  } */

  @override
  void initState() {
    super.initState();
    loadPdf();
    //print("Permission is : ${Permission.manageExternalStorage.status}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Stack(
        children: [
          Center(
            child: (pdfFlePath == null)
                ? const Center(child: CircularProgressIndicator())
                : PdfView(path: pdfFlePath!),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 20,
            right: 10,
            child: Container(
              height: MediaQuery.of(context).size.height / 20,
              decoration: BoxDecoration(
                //color: kVioletColor,
                color:
                    Color.lerp(kVioletColor, Colors.black, 0.9)!.withAlpha(160),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    //margin: Spacing.bottom(8),
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        MdiIcons.closeCircle,
                        color: KWhite,
                        size: 25.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 0.0,
                      fillColor: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                    ),
                  ),
                  if (pdfFlePath != null)
                    Container(
                      //margin: Spacing.bottom(8),
                      child: RawMaterialButton(
                        onPressed: () {
                          saveFile();
                        },
                        child: Icon(
                          MdiIcons.downloadCircleOutline,
                          color: KWhite,
                          size: 25.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 0.0,
                        fillColor: Colors.transparent,
                        padding: const EdgeInsets.all(5.0),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PDFWIDGET extends StatefulWidget {
  final String url;
  final String senderDoc;
  const PDFWIDGET({Key? key, required this.url, required this.senderDoc})
      : super(key: key);

  @override
  State<PDFWIDGET> createState() => _PDFWIDGETState();
}

class _PDFWIDGETState extends State<PDFWIDGET> {
  bool _isLoading = true;
  //late PDFDocument _pdf;
  String? pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    var tempDir = await getTemporaryDirectory();
    print(tempDir.parent);
    print(directory.path);
    final File file = File(
        '${directory.path}/${widget.senderDoc}-${DateTime.now().millisecondsSinceEpoch.toString()}.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(widget.url));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<bool> saveFile() async {
    String name = await readStorage(value: "name");
    try {
      if (await _requestPermission(Permission.manageExternalStorage)) {
        Directory? directory;
        directory = Platform.isAndroid
            ? await getExternalStorageDirectory() //FOR ANDROID
            : await getApplicationSupportDirectory(); //FOR IOS

        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/FELICITY/${widget.senderDoc}";
        directory = Directory(newPath);
        print("Directory look : $directory");

        File saveFile = File(directory.path +
            "/${widget.senderDoc}-${DateTime.now().millisecondsSinceEpoch.toString()}.pdf");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          print("DIRECTORY CREATE");
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          print("DOCUMENTS SAVE");
          await Dio().download(
            widget.url,
            saveFile.path,
          );
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void loadPdf() async {
    String pdfFlePath1 = await downloadAndSavePdf();
    if (!mounted) return;
    setState(() {
      pdfFlePath = pdfFlePath1;
    });
  }

  void download() async {}

  /* void _loadFile() async {
    // Load the pdf file from the internet
    _pdf = await PDFDocument.fromURL(
        'https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf');

    setState(() {
      _isLoading = false;
    });
  } */

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PDFViewer(
            senderDoc: widget.senderDoc,
            url: widget.url,
          );
        }));
      },
      child: Center(
        child: (pdfFlePath == null)
            ? const Center(child: CircularProgressIndicator())
            : ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: PdfView(
                  path: pdfFlePath!,
                  gestureNavigationEnabled: true,
                ),
              ),
      ),
    );
  }
}
