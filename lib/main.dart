import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FooocusApi.dart';

void main() => runApp(const MaterialApp(home: MyImageWidget()));

class MyImageWidget extends StatefulWidget {
  const MyImageWidget({super.key});

  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  String? _imageUrl;
  String? _errorMessage;
  final TextEditingController _queryController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String? savedApiUrl = _prefs.getString('apiUrl');
    if (savedApiUrl != null) {
      _urlController.text = savedApiUrl;
    }
  }

  Future<void> _saveSettings() async {
    String apiUrl = _urlController.text.trim();
    if (apiUrl.isNotEmpty) {
      await _prefs.setString('apiUrl', apiUrl);
    }
  }

  Future<void> _generateImage(String query) async {
    String? apiUrl = _urlController.text.trim();
    await _saveSettings();

    setState(() {
      _imageUrl = null;
      _errorMessage = null;
    });

    try {
      final imageUrl = await getImgFromFooocuseApi(query);
      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      setState(() {
        print(e);
        _errorMessage = 'Failed to generate image: $e';
      });
    }
  }

  Future<void> _showSettingsDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Enter API URL',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _generateImage(_queryController.text.trim());
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stable Diffusion'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _showSettingsDialog();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  labelText: 'Enter Query',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String query = _queryController.text.trim();
                  if (query.isNotEmpty) {
                    _generateImage(query);
                  }
                },
                child: const Text('Search'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: _imageUrl != null
                      ? Image.network(_imageUrl!)
                      : _errorMessage != null
                          ? Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            )
                          : const CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
