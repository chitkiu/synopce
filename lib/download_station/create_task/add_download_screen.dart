import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/icons_constants.dart';
import '../../sdk.dart';
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
  bool _canSelectFile = true;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Add download'),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: GestureDetector(
            onTap: () {
              _sendRequest(context);
            },
            child: doneIcon(context),
          ));
        },
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sendRequest(context);
          },
          child: doneIcon(context),
        ));
      },
      body: Align(
        alignment: AlignmentDirectional.center,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter URL"),
              PlatformTextField(
                keyboardType: TextInputType.url,
                hintText: 'URL',
                onChanged: (newValue) {
                  setState(() {
                    _url = newValue;
                  });
                },
              ),
              const Text("Or select file"),
              GestureDetector(
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
                  if (!_canSelectFile) return;
                  _canSelectFile = false;
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _file = result.files.single;
                    });
                  }
                  _canSelectFile = true;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              const Text("Destination"),
              GestureDetector(
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
                      await SDK.instance.fsSDK.list.listSharedFolder();
                  if (result.success && result.data != null) {
                    List<Directory> data = result.data!.shares;
                    var model = await Navigator.of(context).push(
                        platformPageRoute(
                            context: context,
                            builder: (context) =>
                                SelectDestinationWidget(data)));
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

    var result = await SDK.instance.dsSDK.task.create(
        destination: _destination ?? "",
        filePath: _file?.path,
        uris: (_url.isNotEmpty ? [_url] : null)
    );
    
    if (result.success) {
      Navigator.pop(context);
    } else {
      print('Error: ${result.error}');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Error: ${result.error}'),
      // ));
    }
  }
}
