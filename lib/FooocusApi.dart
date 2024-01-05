import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env/env.dart';

String replicateApiToken = Env.apiKey;

Future<String> create(String query) async {
  // Replace with your actual API token

  String replicateApiToken = Env.apiKey;

  // Replace with your actual endpoint
  String apiUrl = "https://api.replicate.com/v1/predictions";

  // Replace with your actual JSON payload
  var payload = {
    "version":
        "a7e8fa2f96b01d02584de2b3029a8452b9bf0c8fa4127a6d1cfd406edfad54fb",
    "input": {
      "prompt": query,
      "cn_type1": "ImagePrompt",
      "cn_type2": "ImagePrompt",
      "cn_type3": "ImagePrompt",
      "cn_type4": "ImagePrompt",
      "sharpness": 2,
      "image_seed": 1,
      "uov_method": "Disabled",
      "image_number": 1,
      "guidance_scale": 4,
      "refiner_switch": 0.5,
      "negative_prompt": "",
      "style_selections": "Fooocus V2,Fooocus Enhance,Fooocus Sharp",
      "uov_upscale_value": 0,
      "outpaint_selections": "",
      "outpaint_distance_top": 0,
      "performance_selection": "Speed",
      "outpaint_distance_left": 0,
      "aspect_ratios_selection": "1152*896",
      "outpaint_distance_right": 0,
      "outpaint_distance_bottom": 0,
      "inpaint_additional_prompt": ""
    }
  };
  var jsonPayload = jsonEncode(payload);
  Map<String, String> headers = {
    'Authorization': 'Token $replicateApiToken',
    'Content-Type': 'application/json',
  };

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonPayload,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
  } catch (error) {
    print('Error: $error');
    return "Error";
  }
}

Future<String> getPng(String id) async {
  String apiUrl = "https://api.replicate.com/v1/predictions/$id";

  Map<String, String> headers = {
    'Authorization': 'Token $replicateApiToken',
    'Content-Type': 'application/json',
  };

  try {
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );
    print('Response status: ${response.statusCode}');
    print('Response body_1: ${response.body}');
    return response.body;
  } catch (error) {
    print('Error: $error');
    return "Error";
  }
}

Future<String> getImgFromFooocuseApi(String query) async {
  var response = await create(query);
  var responseJson = jsonDecode(response);
  String id = responseJson['id'];
  while (
      !['canceled', 'succeeded', 'failed'].contains(responseJson['status'])) {
    await Future.delayed(Duration(milliseconds: 250));
    response = await getPng(id);
    responseJson = jsonDecode(response);
  }
  final result = await getPng(id);
  print(jsonDecode(result)["output"][0]);
  return jsonDecode(result)["output"][0];
}
