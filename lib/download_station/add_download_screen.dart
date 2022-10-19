import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../constants.dart' as Constants;

class AddDownloadTaskWidget extends StatefulWidget {
  const AddDownloadTaskWidget({super.key});

  @override
  State<AddDownloadTaskWidget> createState() => _AddDownloadTaskWidgetState();
}

class _AddDownloadTaskWidgetState extends State<AddDownloadTaskWidget> {
  String _file = "";
  String _url = "";
  String _destination = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add download'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("URL"),
          TextField(
            onChanged: (text) {
              setState(() {
                _url = text;
              });
            },
          ),
          const Text("Destination"),
          TextField(
            onChanged: (text) {
              setState(() {
                _destination = text;
              });
            },
          ),
          if (_file.isNotEmpty) Text('Selected file: $_file'),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                var singlePath = result.files.single.path;
                if (singlePath != null) {
                  setState(() {
                    _file = singlePath;
                  });
                }
              }
            },
            child: const Text('Pick file!'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sendRequest(context),
        tooltip: 'Create task',
        child: const Icon(Icons.done),
      ),
    );
  }

  void _sendRequest(BuildContext context) async {
    if (_destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter destination'),
      ));
      return;
    }
    if (_url.isEmpty && _file.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select file or enter url'),
      ));
      return;
    }
    var result = await Constants.sdk.api.addDownload(
        destination: _destination,
        filePath: (_file.isNotEmpty ? _file : null),
        url: (_url.isNotEmpty ? _url : null));

    result.ifSuccess((p0) {
      //TODO It's wrong way
      Navigator.pop(context);
    }).ifError((p0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${p0.name}'),
      ));
    });
  }
}
