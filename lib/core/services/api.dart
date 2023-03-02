import "dart:convert";
import "dart:core";
import 'package:http/http.dart' as http;

class Api {
  String URLADP = "https://twsv03.adwapay.cm/";

  String merchentKey = 'CODEDIG1';
  String subscriptonKey = 'CO3PMF8QCMXXG1';
  String applicationKey = 'AP3PMF8QCMXXDJB2Y';
  String credentials = 'CODEDIG1:CO3PMF8QCMXXG1';

  String URLADPPROD = "https://apiv03.adwapay.com/";
  String credentialsProd = 'CODEDEG1:CO1DZ8ZKJFXXG1';
  String merchentKeyProd = 'CODEDEG1';
  String subscriptonKeyProd = 'CO1DZ8ZKJFXXG1';
  String applicationKeyProd = 'AP1DZ8ZKJFXX55A3P';

  Future getADPToken() async {
    var response = await http.post(Uri.parse(URLADPPROD + 'getADPToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'Basic ' + base64.encode(utf8.encode(credentialsProd)),
        },
        body: jsonEncode(<String, dynamic>{'application': applicationKeyProd}));
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  Future getFees(token, amount) async {
    var response = await http.post(Uri.parse(URLADPPROD + 'getFees'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH-API-TOKEN': 'Bearer ' + token,
          'AUTH-API-SUBSCRIPTION': subscriptonKeyProd,
        },
        body:
            jsonEncode(<String, dynamic>{'amount': amount, 'currency': 'XAF'}));
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  Future checkStatus(token, meanCode, adpFootprint) async {
    var response = await http.post(Uri.parse(URLADPPROD + 'paymentStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'AUTH-API-TOKEN': 'Bearer ' + token,
          'AUTH-API-SUBSCRIPTION': subscriptonKeyProd,
        },
        body: jsonEncode(<String, dynamic>{
          'meanCode': meanCode,
          'adpFootprint': adpFootprint
        }));
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  Future requestToPay(
      token, meanCode, paymentNumber, orderNumber, amount, feesAmount) async {
    var response = await http.post(
      Uri.parse(URLADPPROD + 'requestToPay'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'AUTH-API-TOKEN': 'Bearer ' + token,
        'AUTH-API-SUBSCRIPTION': subscriptonKeyProd,
      },
      body: jsonEncode(<String, dynamic>{
        "meanCode": meanCode,
        "paymentNumber": paymentNumber,
        "orderNumber": orderNumber,
        "amount": amount,
        "currency": "XAF",
        "feesAmount": feesAmount
      }),
    );
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }

  Future convertCurrency(String currency, int amount) async {
    var response = await http.get(
      Uri.parse(
          "https://api.getgeoapi.com/v2/currency/convert?api_key=d38894ea8ba8480be0e85bb2c194719040ab90e4&from=EUR&to=" +
              currency +
              "&amount=" +
              amount.toString() +
              "&format=json"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseJson = jsonDecode(response.body);
    return responseJson;
  }
}
