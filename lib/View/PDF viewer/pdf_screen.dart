import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:non_attending/Utils/resources/app_theme.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;

  const PdfViewerPage({super.key, required this.url});
  
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  File? Pfile;
  bool isLoading = false;

  Future<void> loadNetwork(String uurl) async {
    setState(() {
      isLoading = true;
    });
    print("kvkrkkr ${widget.url}");
    try {
      var url = '$uurl';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final filename = basename(url);
        final dir = await getApplicationDocumentsDirectory();
        var file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          Pfile = file;
        });
        print('PDF file downloaded: ${Pfile!.path}');
      } else {
        print('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading PDF: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNetwork(widget.url);
    diableFuction();
  }

  diableFuction() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/images/back.png",
              height: 30,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "PDF Viewer",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Pfile != null
              ? PDFView(
                  filePath: Pfile!.path,
                  onRender: (_pages) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onError: (error) {
                    print('Error rendering PDF: $error');
                  },
                  onPageError: (page, error) {
                    print('Error on page $page: $error');
                  },
                )
              : const Center(child: Text("Error loading PDF")),
    );
  }
}
