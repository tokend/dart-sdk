import 'dart:convert';

import 'package:dart_sdk/api/base/model/remote_file.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parse and compare', () async {
    var json = """
            {
              "key": "dpurex4inf5nahjrsqkkimns6ascqpnddoe2roficpj7xtqorlvw4jd3lsglzzh4a4ctkaxuigqyht6i3t2usyu2",
              "name": "sample.pdf",
              "mime_type": "application/pdf"
            }
        """;

    var remoteFileJson = RemoteFile.fromJson(jsonDecode(json));

    expect(
      remoteFileJson.key,
      "dpurex4inf5nahjrsqkkimns6ascqpnddoe2roficpj7xtqorlvw4jd3lsglzzh4a4ctkaxuigqyht6i3t2usyu2",
    );

    expect(
      remoteFileJson.name,
      "sample.pdf",
    );

    expect(
      remoteFileJson.mimeType,
      "application/pdf",
    );
  });

  test('get url', () async {
    var file = RemoteFile(
        "dpurex4inf5nahjrsqkkimns6ascqpnddoe2roficpj7xtqorlvw4jd3lsglzzh4a4ctkaxuigqyht6i3t2usyu2",
        "file.pdf",
        "application/pdf");

    var storageRoot = "https://tokend.io/storage/";
    expect(
      file.getUrl(storageRoot.substring(0, storageRoot.length - 1)),
      "https://tokend.io/storage/dpurex4inf5nahjrsqkkimns6ascqpnddoe2roficpj7xtqorlvw4jd3lsglzzh4a4ctkaxuigqyht6i3t2usyu2",
      reason: "Trailing slash must be added if required",
    );

    expect(
        "https://tokend.io/storage/dpurex4inf5nahjrsqkkimns6ascqpnddoe2roficpj7xtqorlvw4jd3lsglzzh4a4ctkaxuigqyht6i3t2usyu2",
        file.getUrl("https://tokend.io/storage/"));
  });

  test('is image', () async {
    var imageFiles = List.of([
      RemoteFile("k", "n", "image/jpeg"),
      RemoteFile("k", "n", "image/png")
    ]);
    var notImage = RemoteFile("k", "n", "application/pdf");

    expect(imageFiles.map((file) => file.isImage).contains(false), false);
    expect(notImage.isImage, false);
  });

  test('javascript', () async {
    var fakeNullJsFile=  RemoteFile("", "", "");
    RemoteFile? nullFile;

    expect(fakeNullJsFile.isReallyNullOrNullAccordingToTheJavascript(), true);
    expect(nullFile.isReallyNullOrNullAccordingToTheJavascript(), true);
  });
}
