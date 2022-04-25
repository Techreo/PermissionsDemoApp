import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Network extends StatefulWidget {
  const Network({Key? key}) : super(key: key);

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  bool downloading = true;
  String fileUrl = "https://picsum.photos/250";
  String? imagePath;

  Future<String> get _localPath async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      if (kDebugMode) {
        print("Cannot get download folder path: " + stack.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot get download folder path')),
      );
    }
    if (kDebugMode) {
      print("PATH: " + directory!.path);
    }
    return directory!.path;
  }

  Future _downloadNetworkImage() async {
    _showSnack("Downloading image. Please wait...");
    Dio dio = Dio();
    imagePath = null;
    var dir = await _localPath;

    String formattedDate =
        DateFormat('yyyy-MM-dd_kk-mm-ss').format(DateTime.now());
    String savePath = "$dir/image$formattedDate.jpeg";

    if (kDebugMode) {
      print(savePath);
    }

    try {
      await dio.download(fileUrl, savePath, onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
        });
      });
      imagePath = savePath;
      setState(() {
        downloading = false;
      });
      _showSnack("File is saved to download folder.");
    } on DioError catch (e) {
      if (kDebugMode) {
        print("An error occurred - ${e.message}: $e");
      }
      _showSnack(e.message);
    }
  }

  Future _showSnack(String message) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Download file from URL"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              Text("File URL: $fileUrl"),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses =
                      await [Permission.storage].request();
                  if (statuses[Permission.storage]!.isGranted) {
                    await _downloadNetworkImage();
                  } else {
                    _showSnack('No permission to read and write.');
                  }
                },
                child: const Text("Download File"),
              ),
              downloading
                  ? Image.asset('assets/transparent.png', width: 1, height: 1)
                  : Image.file(File(imagePath!))
            ],
          ),
        ));
  }
}
