import 'dart:convert';

import 'package:http/http.dart' as http;

enum _endpointsEnum { getPlot }

final Map<_endpointsEnum, String> _endpoints = {
  _endpointsEnum.getPlot: "getPlot",
};

enum _responseKeysEnum {
  status,
  images,
  properties,
}

final Map<_responseKeysEnum, String> _responseKeys = {
  _responseKeysEnum.properties: "properties",
  _responseKeysEnum.images: "images",
  _responseKeysEnum.status: "status"
};

enum _statusesEnum {
  success,
  failure,
}

final Map<_statusesEnum, String> _statuses = {
  _statusesEnum.success: "success",
  _statusesEnum.failure: "failure"
};

final local_ip = "http://127.0.0.1";
final global_ip = "http://185.104.248.237";
final https_ip = "https://sharemsuic.site:8001";


class PlotApi {

  final String _url = https_ip;
  final _port = 8000;

  Future<Map<String, dynamic>?> getPlot(List<DateTime> dates) async {
    if (dates.length < 2) {
      return null;
    }
    DateTime left = dates[0];
    DateTime right = dates[1];
    String req = '$_url:$_port/${_endpoints[_endpointsEnum.getPlot]}/';

    var body = jsonEncode(<String, dynamic>{
      "left": {"year": left.year, "month": left.month, "day": left.day},
      "right": {"year": right.year, "month": right.month, "day": right.day},
    });

    Map<String, String> headers = {"Accept": "application/json", "content-type": "application/json"};

    print(req);
    print(body);
    final response = await http.post(
      Uri.parse(req),
      body: body,
      headers: headers,
    );
    print(response.statusCode);

    if (response.statusCode != 200) {
      return null;
    }

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse[_responseKeys[_responseKeysEnum.status]] == _statuses[_statusesEnum.failure]) {
      return null;
    }
    print(jsonResponse);
    return jsonResponse;
  }
}
