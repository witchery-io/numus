import 'package:http/http.dart' as http;

class WebClient {
  const WebClient();

  Future getBalanceByAddress() {
    return http.get('');
  }
}
