import 'package:dsm_app/sdk.dart';
import 'package:dsm_sdk/file_station/fs_file_info_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'select_destination_screen.dart';

class AddDownloadTaskWidget extends StatefulWidget {
  const AddDownloadTaskWidget({super.key});

  @override
  State<AddDownloadTaskWidget> createState() => _AddDownloadTaskWidgetState();
}

class _AddDownloadTaskWidgetState extends State<AddDownloadTaskWidget> {
  PlatformFile? _file;
  String _url = "";
  String? _destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add download'),
      ),
      body: Align(
        alignment: AlignmentDirectional.center,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter URL"),
              TextField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  labelText: 'URL',
                ),
                onChanged: (newValue) {
                  setState(() {
                    _url = newValue;
                  });
                },
              ),
              const Text("Or select file"),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                            (_file != null ? _file?.name ?? "" : "Select file"),
                            overflow: TextOverflow.ellipsis,
                          )),
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
                onTap: () async {
                  FilePickerResult? result =
                  await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _file = result.files.single;
                    });
                  }
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Text("Destination"),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        (_destination != null && _destination!.isNotEmpty
                            ? _destination ?? ""
                            : "Select destination"),
                        overflow: TextOverflow.ellipsis,
                      )),
                      const Icon(Icons.arrow_right),
                    ],
                  ),
                ),
                onTap: () async {
                  var result =
                      await SDK.instance.sdk.fsSDK.getSharedFolderList();
                  if (result.isSuccess) {
                    List<FSFileInfoModel> data = result.successValue;
                    var model = await showDialog<FSFileInfoModel>(
                      context: context,
                      builder: (context) => SelectDestinationWidget(data),
                    );
                    setState(() {
                      _destination = model?.path.substring(1) ?? "";
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _sendRequest(context),
        tooltip: 'Create task',
        child: const Icon(Icons.done),
      ),
    );
  }

  void _sendRequest(BuildContext context) async {
    if (_destination == null || _destination?.isEmpty == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter destination'),
      ));
      return;
    }
    if (_url.isEmpty && _file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select file or enter url'),
      ));
      return;
    }
    var result = await SDK.instance.sdk.dsSDK.addDownload(
        destination: _destination ?? "",
        filePath: (_file != null ? _file!.path : null),
        url: (_url.isNotEmpty ? _url : null));

    result.ifSuccess((p0) {
      Navigator.pop(context);
    }).ifError((p0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${p0.name}'),
      ));
    });
  }
}
