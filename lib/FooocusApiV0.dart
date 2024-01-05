import 'package:replicate/replicate.dart';
import 'package:dotenv/dotenv.dart';
import 'env/env.dart';
import 'dart_replicate.dart' as app;

Future<String> fooocusApi() async {
  final model = 'konieshadow/fooocus-api:a7e8fa2f';
  final inputs = {
    'prompt': 'a red cat, 4k photo',
  };

  final output = await app.Replicate.run(model, inputs);
  print(output);
  return output;
}




/* Future<String> fooocusApi() async {
  Replicate.apiKey = Env.apiKey;
  Map<String, dynamic> input_ = {"prompt": "an orange car"};

  try {
    // Create the prediction
    Prediction? prediction = await Replicate.instance.predictions.create(
      version:
          "a7e8fa2f96b01d02584de2b3029a8452b9bf0c8fa4127a6d1cfd406edfad54fb",
      input: input_,
    );

    // Poll for prediction status, handling null id safely
    while (prediction?.status != "completed") {
      await Future.delayed(Duration(seconds: 5));
      if (prediction?.id != null) {
        prediction =
            await Replicate.instance.predictions.get(id: prediction.id);
      } else {
        print("Prediction ID is null, retrying in 5 seconds...");
      }
    }

    // Process the completed prediction
    print(prediction?.output);

    // Ensure prediction is not null before calling toString()
    if (prediction != null) {
      return prediction.toString();
    } else {
      return "Prediction result is null";
    }
  } catch (e) {
    print("Error: $e");
    return ("runtime error");
  }
}
 */