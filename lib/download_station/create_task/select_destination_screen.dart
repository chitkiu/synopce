import 'package:dsm_sdk/file_station/fs_file_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tree/flutter_tree.dart';

import '../../sdk.dart';

class SelectDestinationWidget extends StatelessWidget {
  final List<FSFileInfoModel> models;

  const SelectDestinationWidget(this.models, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = models.where((element) => element.isDir).map((e) => TreeNodeData(
          title: e.name,
          checked: false,
          expaned: false,
          extra: e,
          children: List.empty(),
        ));
    return AlertDialog(
      title: const Text("Select directory on server"),
      content: TreeView(
          data: data.toList(),
          lazy: true,
          showCheckBox: true,
          load: _load,
          onCheck: (checked, node) {
            var data = node.extra;
            if (data is FSFileInfoModel) {
              Navigator.pop(context, data);
            }
          }),
    );
  }

  Future<List<TreeNodeData>> _load(TreeNodeData parent) async {
    var extra = parent.extra;
    if (extra is FSFileInfoModel) {
      var newDirs = await SDK.instance.sdk.fsSDK.getFolderList(extra.path);
      if (newDirs.isSuccess) {
        return newDirs.successValue
            .where((element) => element.isDir)
            .map((e) => TreeNodeData(
                  title: e.name,
                  checked: false,
                  expaned: false,
                  extra: e,
                  children: List.empty(),
                ))
            .toList();
      }
    }
    return List.empty();
  }
}
