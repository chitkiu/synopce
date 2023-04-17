import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/api_service/api_service.dart';
import '../../../common/data/models/api_error_exception.dart';
import '../../../common/extensions/snackbar_extension.dart';
import '../../../common/ui/app_bar_title.dart';
import '../../../common/ui/colors.dart';
import '../../../common/ui/icons_constants.dart';
import '../../../common/ui/text_style.dart';
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
        title: const AppBarTitle('Add download'),
        cupertino: (context, platform) {
          return CupertinoNavigationBarData(
              trailing: CupertinoButton(
                onPressed: () {
                  _sendRequest(context);
                  },
                child: doneIcon(context),
              )
          );
        },
      ),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sendRequest(context);
          },
          child: doneIcon(context, color: AppColors.onPrimary),
        ));
      },
      body: Align(
        alignment: AlignmentDirectional.center,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enter URL", style: AppBaseTextStyle.mainStyle),
              const Padding(padding: EdgeInsets.only(top: 8)),
              PlatformTextField(
                keyboardType: TextInputType.url,
                hintText: 'URL',
                onChanged: (newValue) {
                  setState(() {
                    _url = newValue;
                  });
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              Text("Or select file", style: AppBaseTextStyle.mainStyle),
              const Padding(padding: EdgeInsets.only(top: 8)),
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
                  final permissionStatus = await Permission.storage.status;
                  if (permissionStatus.isGranted || permissionStatus.isLimited) {
                    await _pickFile();
                  } else if (permissionStatus.isDenied) {
                    final permissionResponse = await Permission.storage.request();

                    if (permissionResponse.isGranted || permissionResponse.isLimited) {
                      await _pickFile();
                    } else if (permissionResponse.isDenied) {
                      await _showGivePermissionDialog(context);
                    } else if (permissionResponse.isPermanentlyDenied || permissionResponse.isRestricted) {
                      await _showBlockPermissionDialog(context);
                    }
                  } else if (permissionStatus.isPermanentlyDenied || permissionStatus.isRestricted) {
                    await _showBlockPermissionDialog(context);
                  }
                  _canSelectFile = true;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              Text("Destination", style: AppBaseTextStyle.mainStyle),
              const Padding(padding: EdgeInsets.only(top: 8)),
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
                  try {
                    var result = await ApiService.api.fsService.listSharedFolder();
                    List<FileStationDirectory> data = result.shares;
                    var model =
                        await Get.to(() => SelectDestinationWidget(data));
                    setState(() {
                      _destination = model?.path.substring(1) ?? "";
                    });
                  } on Exception {
                    //Do nothing
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
      errorSnackbar(
        'Enter destination',
      );
      return;
    }
    if (_url.isEmpty && _file == null) {
      errorSnackbar(
        'Select file or enter url',
      );
      return;
    }

    try {
      await ApiService.api.dsService.create(
          destination: _destination ?? "",
          filePath: _file?.path,
          uris: (_url.isNotEmpty ? [_url] : null));
      Get.back();
    } on ApiErrorException catch (e) {
      errorSnackbar(e.errorType.toString());
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _file = result.files.single;
        });
      }
    } on PlatformException catch (e) {
      Get.log.printError(info: e.toString());
    }
  }

  Future<void> _showGivePermissionDialog(BuildContext context) => showPlatformDialog(
      context: context,
      material: MaterialDialogData(
        builder: (context) {
          return AlertDialog(
            content: Text("Please, give permission for access to storage"),
            title: Text("Need permission"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      ),
      cupertino: CupertinoDialogData(
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("Please, give permission for access to storage"),
            title: Text("Need permission"),
            actions: [
              CupertinoDialogAction(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      )
  );

  //TODO Improve dialog
  Future<void> _showBlockPermissionDialog(BuildContext context) => showPlatformDialog(
      context: context,
      material: MaterialDialogData(
        builder: (context) {
          return AlertDialog(
            content: Text("Please, give permission for access to storage in settings!"),
            title: Text("Need permission"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      ),
      cupertino: CupertinoDialogData(
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("Please, give permission for access to storage in settings!"),
            title: Text("Need permission"),
            actions: [
              CupertinoDialogAction(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        },
      )
  );
}
