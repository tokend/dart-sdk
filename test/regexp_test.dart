import 'package:flutter_test/flutter_test.dart';

void main() {
  String? getNumberParamFromLink(String link, String param) {
    var pagingParam =
        RegExp('$param=(\\d+)', multiLine: true).firstMatch(link)?.group(1);
    print('Result: $pagingParam');
  }

  test('get pagination paramter', () async {
    var link =
        "/v3/history?filter%5Bbalance%5D=BAWKBCNP7XTLGO5YXTRMC6M2AIYQP6LDHKYHASDLAOGRXRLA7I74HWHZ&include=operation%2Coperation.details%2Ceffect&page%5Bcursor%5D=468065535918081&page%5Blimit%5D=15&page%5Border%5D=asc";
    var page = getNumberParamFromLink(Uri.decodeFull(link), 'page\\[cursor\\]');
    print(page);
  });

  test('general expressions', () async {
    const text = '''
      Lorem Ipsum is simply dummy text of the 123.456 printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an 12:30 unknown printer took a galley of type and scrambled it to make a
      23.4567
      type specimen book. It has 445566 survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
    ''';

    final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
    final doubleRegex = RegExp(r'\s+(\d+\.\d+)\s+', multiLine: true);
    final timeRegex = RegExp(r'\s+(\d{1,2}:\d{2})\s+', multiLine: true);
    print(intRegex.allMatches(text).map((m) => m.group(0)));
    print(doubleRegex.allMatches(text).map((m) => m.group(0)));
    print(timeRegex.allMatches(text).map((m) => m.group(0)));
  });
}
