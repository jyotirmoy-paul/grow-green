import 'dart:collection';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

abstract class FirebaseStorageUploadService {
  static FirebaseStorage get _storage => FirebaseStorage.instance;

  static UploadTask _uploadFile({required File file, required String fStorePath}) {
    final metaData = SettableMetadata(contentType: "text/html");
    return _storage.ref(fStorePath).putFile(file, metaData);
  }

  static Future<String> _getDownloadURL({required String fStorePath}) async {
    return await _storage.ref(fStorePath).getDownloadURL();
  }

  static Future<String> uploadFileAndGetDownloadUrl({required File file, required String fStorePath}) async {
    await _uploadFile(file: file, fStorePath: fStorePath);
    final downloadUrl = await _getDownloadURL(fStorePath: fStorePath);
    return downloadUrl;
  }

  static Future<String> getHostedLinkFor(String nativeDeeplink) async {
    String html = "<a href=$nativeDeeplink>Open in App</a>";
    final htmlFile = await exportStringToHtmlFile(string: html);
    final htmlFileBaseName = path.basename(htmlFile.path);
    final downloadUrl = await FirebaseStorageUploadService.uploadFileAndGetDownloadUrl(
      file: htmlFile,
      fStorePath: path.join("links", htmlFileBaseName),
    );
    return downloadUrl;
  }

  static Future<File> exportStringToHtmlFile({required String string}) async {
    final id = const Uuid().v4();
    final tempDir = await path_provider.getTemporaryDirectory();
    final classFile = File(path.join(tempDir.path, "$id.html"));
    await classFile.writeAsString(string);
    return classFile;
  }
}
