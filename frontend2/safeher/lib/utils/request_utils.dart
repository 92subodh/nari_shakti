import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safeher/constants/connection_constants.dart';
import 'package:path/path.dart';

import 'logging_utils.dart';

class ServerResponse {
  final String? message;
  final bool success;
  final dynamic data;

  ServerResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory ServerResponse.successJson(Map<String, dynamic> json) {
    return ServerResponse(
      success: true,
      message: json['message'] as String?,
      data: json['data'],                  
    );
  }

  factory ServerResponse.errorJson(Map<String, dynamic> json) {
    return ServerResponse(
      success: false,
      message: json['message'] as String?,
      data: json['data'],       
    );
  }
}


Future<ServerResponse> fetch({route, params}) async {
  String queryString =
      params?.entries
          ?.map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
          )
          .join('&') ??
      "";

  var url = Uri.parse('$serverBaseUrl$route?$queryString');
  logging.i(url);
  logging.i("params: ${params.toString()}");

  var res = await http.get(url);

  Map<String, dynamic> body = jsonDecode(res.body);
  if (res.statusCode != 200) {
    logging.e("Error fetching data for route $route");
    return ServerResponse.errorJson(body);
  } else {
    return ServerResponse.successJson(body);
  }
}

Future<ServerResponse> post({route, body}) async {
  var url = Uri.parse('$serverBaseUrl$route');
  var res = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  Map<String, dynamic> resBody = jsonDecode(res.body);
  if (res.statusCode != 200) {
    logging.e("Error fetching data for route $route");
    return ServerResponse.errorJson(resBody);
  } else {
    return ServerResponse.successJson(resBody);
  }
}

Future<ServerResponse> uploadFile({
  route,
  file,
  Map<String, String>? fields,
}) async {
  var url = Uri.parse('$serverBaseUrl$route');
  var request = http.MultipartRequest('POST', url)
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: basename(file.path),
      ),
    );

  if (fields != null) {
    request.fields.addAll(fields);
  }

  var res = await request.send();
  Map<String, dynamic> resBody = jsonDecode(await res.stream.bytesToString());
  if (res.statusCode != 200) {
    logging.e("Error fetching data for route $route");
    return ServerResponse.errorJson(resBody);
  } else {
    return ServerResponse.successJson(resBody);
  }
}
