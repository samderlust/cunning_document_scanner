import 'dart:async';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _scannedPath;
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openAsset(''),
    );
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: onPressed, child: const Text("Add Pictures")),
            // for (var picture in _pictures) Image.file(File(picture))
            Text(_scannedPath ?? ''),
            if (_scannedPath != null && _scannedPath!.isNotEmpty) ...[
              TextButton(
                onPressed: () async {
                  _pdfController
                      .loadDocument(PdfDocument.openFile(_scannedPath!));
                },
                child: Text("Open"),
              ),
              SizedBox(
                height: 200,
                child: PdfView(
                  controller: _pdfController,
                ),
              )
            ]
          ],
        )),
      ),
    );
  }

  void onPressed() async {
    try {
      final p = await CunningDocumentScanner.getPictures();
      print("RES $p");
      if (!mounted) return;
      setState(() {
        _scannedPath = p;
      });
    } catch (exception) {
      // Handle exception here
    }
  }
}
