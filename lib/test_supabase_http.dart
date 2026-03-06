import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final url = Uri.parse(
    'https://feycrgmmimlmrnfxafmb.supabase.co/rest/v1/app_config?select=*',
  );
  final response = await http.get(
    url,
    headers: {
      'apikey': 'sb_publishable_R-6ByLVRzsDVb1vacQStvA_QpMHskX1',
      'Authorization': 'Bearer sb_publishable_R-6ByLVRzsDVb1vacQStvA_QpMHskX1',
    },
  );
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
