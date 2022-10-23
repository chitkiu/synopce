// import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:dsm_sdk/file_station/fs_file_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../sdk.dart';

class SelectDestinationWidget extends StatelessWidget {
  final List<FSFileInfoModel> models;

  const SelectDestinationWidget(this.models, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var root = TreeNode(id: "Root");
    root.addChildren(
        models.where((element) => element.isDir).map((e) => TreeNode(
              id: e.path,
              data: e,
            )));
    var controller = TreeViewController(rootNode: root);
    return AlertDialog(
      title: const Text("Select directory on server"),
      content: SizedBox(
        height: 500,
        width: 400,
        child: TreeView(
          controller: controller,
          nodeBuilder: (context, node) {
            return const NodeTreeView();
          },
        ),
      ),
    );
  }
}

class NodeTreeView extends StatelessWidget {
  const NodeTreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scope = TreeNodeScope.of(context);
    var data = scope.node.data;
    if (data is FSFileInfoModel) {
      return InkWell(
          onTap: () async {
            if (scope.isExpanded) {
              scope.collapse(context);
            } else {
              var newDirs =
                  await SDK.instance.sdk.fsSDK.getFolderList(data.path);
              if (newDirs.isSuccess) {
                var items = newDirs.successValue
                    .where((element) => element.isDir)
                    .map((e) => TreeNode(
                          id: e.path,
                          data: e,
                        ))
                    .toList();
                scope.node.addChildren(items);
                scope.expand(context);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: scope.indentation,
                    height: double.infinity,
                  ),
                  const ExpandNodeIcon(
                    padding: EdgeInsets.zero,
                    size: 20,
                  ),
                  Expanded(
                      child: Text(
                    data.name,
                    overflow: TextOverflow.ellipsis,
                  )),
                  TextButton(
                    child: const Text("Select"),
                    onPressed: () {
                      Navigator.pop(context, data);
                    },
                  ),
                ]),
          ));
    } else {
      return Container();
    }
  }
}
