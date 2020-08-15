import 'dart:convert';
import 'package:http_logger/http_logger.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:najibkado/utils/constant.dart';

//Middleware for sending request
HttpWithMiddleware http = HttpWithMiddleware.build(
    requestTimeout: Duration(seconds: 30),
    middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

class CallApi {
  //sending a post request
  postData(data, apiUrl) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  //sending a post request for current user
  postDataCurrentUser(data, apiUrl, token) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeadersLogin(token));
  }

  //sending a put request for current user
  putDataCurrentUser(data, apiUrl, token) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.put(fullUrl,
        body: jsonEncode(data), headers: _setHeadersLogin(token));
  }

  //sending a delete request for current user
  deleteDataCurrentUser(apiUrl, token) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.delete(fullUrl, headers: _setHeadersLogin(token));
  }

  //sending a get request for current user
  getDataCurrentUser(apiUrl, token) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.get(fullUrl, headers: _setHeadersLogin(token));
  }

  //sending a get request
  getData(apiUrl) async {
    var fullUrl = appApiUrl + apiUrl;
    return await http.get(fullUrl,
        headers: _setHeaders().timeout(const Duration(seconds: 300)));
  }

  //Setting headers
  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};

  //Setting login headers
  _setHeadersLogin(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + token,
      };
}
