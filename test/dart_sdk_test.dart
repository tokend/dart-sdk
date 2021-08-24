import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

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
    // var tmp = CreateTfaRequestBody("test");

    var tmp = """{
  "data": [
    {
      "id": "1",
      "type": "account-roles",
      "attributes": {
        "details": {
          
        }
      },
      "relationships": {
        "rules": {
          "data": [
            {
              "id": "1",
              "type": "account-rules"
            }
          ]
        }
      }
    },
    {
      "id": "2",
      "type": "account-roles",
      "attributes": {
        "details": {
          
        }
      },
      "relationships": {
        "rules": {
          "data": [
            
          ]
        }
      }
    },
    {
      "id": "3",
      "type": "account-roles",
      "attributes": {
        "details": {
          
        }
      },
      "relationships": {
        "rules": {
          "data": [
            {
              "id": "3",
              "type": "account-rules"
            },
            {
              "id": "4",
              "type": "account-rules"
            },
            {
              "id": "6",
              "type": "account-rules"
            },
            {
              "id": "9",
              "type": "account-rules"
            },
            {
              "id": "16",
              "type": "account-rules"
            },
            {
              "id": "19",
              "type": "account-rules"
            },
            {
              "id": "20",
              "type": "account-rules"
            },
            {
              "id": "22",
              "type": "account-rules"
            }
          ]
        }
      }
    },
    {
      "id": "4",
      "type": "account-roles",
      "attributes": {
        "details": {
          
        }
      },
      "relationships": {
        "rules": {
          "data": [
            {
              "id": "3",
              "type": "account-rules"
            },
            {
              "id": "4",
              "type": "account-rules"
            },
            {
              "id": "5",
              "type": "account-rules"
            },
            {
              "id": "6",
              "type": "account-rules"
            },
            {
              "id": "7",
              "type": "account-rules"
            },
            {
              "id": "9",
              "type": "account-rules"
            },
            {
              "id": "12",
              "type": "account-rules"
            },
            {
              "id": "13",
              "type": "account-rules"
            },
            {
              "id": "16",
              "type": "account-rules"
            },
            {
              "id": "17",
              "type": "account-rules"
            },
            {
              "id": "19",
              "type": "account-rules"
            },
            {
              "id": "20",
              "type": "account-rules"
            },
            {
              "id": "21",
              "type": "account-rules"
            },
            {
              "id": "22",
              "type": "account-rules"
            }
          ]
        }
      }
    },
    {
      "id": "5",
      "type": "account-roles",
      "attributes": {
        "details": {
          
        }
      },
      "relationships": {
        "rules": {
          "data": [
            {
              "id": "3",
              "type": "account-rules"
            },
            {
              "id": "4",
              "type": "account-rules"
            },
            {
              "id": "5",
              "type": "account-rules"
            },
            {
              "id": "6",
              "type": "account-rules"
            },
            {
              "id": "7",
              "type": "account-rules"
            },
            {
              "id": "9",
              "type": "account-rules"
            },
            {
              "id": "12",
              "type": "account-rules"
            },
            {
              "id": "13",
              "type": "account-rules"
            },
            {
              "id": "16",
              "type": "account-rules"
            },
            {
              "id": "17",
              "type": "account-rules"
            },
            {
              "id": "19",
              "type": "account-rules"
            },
            {
              "id": "20",
              "type": "account-rules"
            },
            {
              "id": "21",
              "type": "account-rules"
            },
            {
              "id": "22",
              "type": "account-rules"
            }
          ]
        }
      }
    }
  ],
  "included": [
    
  ],
  "links": {
    "first": "",
    "last": "",
    "next": "/v3/account_roles?page%5Blimit%5D=15&page%5Bnumber%5D=1&page%5Border%5D=asc",
    "prev": "",
    "self": "/v3/account_roles?page%5Blimit%5D=15&page%5Bnumber%5D=0&page%5Border%5D=asc"
  }
}""";

    print(jsonDecode(tmp));

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
