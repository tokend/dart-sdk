import 'package:flutter_test/flutter_test.dart';
import 'package:japx/japx.dart';

class Tmp {
  String field1;
  String field2;

  Tmp(this.field1, this.field2);

  Map<String, dynamic> toJson() => {
        'field1': field1,
        'field2': field2,
      };
}

void main() {
  test('adds one to input values', () async {
   /* var tmp = Tmp("test", '1');
    print(Japx.encode(tmp.toJson()));*/

    print(null.toString());
    /*CustomRequestsApi customRequestsApi = CustomRequestsApi(
        CustomRequestService(),
        Dio()..interceptors.add(LogInterceptor(requestBody: true)));
    var response = await customRequestsApi.patch(
        "http://api.rdemo.tokend.io/integrations/history",
        query: null,
        body: tmp.toJson());
    print(response["data"]);*/
  });
}
