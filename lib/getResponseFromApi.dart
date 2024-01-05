import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getResponseFromApi(String query, String? apiURL) async {
  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('$apiURL/sdapi/v1/txt2img'));
  request.body = json.encode({
    "prompt": query,
    "negative_prompt": "",
    "seed": 1,
    "steps": 20,
    "width": 512,
    "height": 512,
    "cfg_scale": 7,
    "sampler_name": "DPM++ 2M Karras",
    "n_iter": 1,
    "batch_size": 1
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print('we got somethin');
  if (response.statusCode == 200) {
    String responseStr = (await response.stream.bytesToString());
    Map<String, dynamic> jsonData = json.decode(responseStr);
    print(jsonData["images"]);
    var stringResponse = jsonData["images"][0];
    return stringResponse;
  } else {
    print('status aint got it');
    return ("failed to generate");
  }
}
